package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func main() {
	// Set up an explicit logger that writes to Standard Error (stderr)
	// This ensures Slurm hooks it up to our .log file captures cleanly
	logger := log.New(os.Stderr, "[GO-PARSER] ", log.LstdFlags|log.Lshortfile)

	// Forensic check: Ensure the binary isn't launched completely blind
	nodeName := os.Getenv("SLURM_NODENAME")
	if nodeName == "" {
		nodeName = "standalone-localhost"
	}
	logger.Printf("Parser initializing task routines on node: %s", nodeName)

	// Global crash capture mechanism (Panic Recovery)
	defer func() {
		if r := recover(); r != nil {
			logger.Fatalf("FATAL RUNTIME PANIC DETECTED: %v", r)
		}
	}()

	var totalBases int64
	var gcCount int64

	// Expand stream buffer allocation to 16MB page frames
	scanner := bufio.NewReaderSize(os.Stdin, 16*1024*1024)
	lineCount := 0

	for {
		lineBytes, isPrefix, err := scanner.ReadLine()
		if err != nil {
			// Cleanly verify if stream hit a real EOF or a broken cluster socket
			if err.Error() == "EOF" {
				logger.Println("Data stream pipe completed successfully (EOF reached).")
			} else {
				logger.Printf("Stream interrupted unexpectedly with error: %v", err)
			}
			break
		}
		if isPrefix {
			logger.Println("Warning: Skipping abnormally long line exceeding page block limit.")
			continue
		}

		lineCount++

		if lineCount%4 == 2 {
			if len(lineBytes) == 0 {
				logger.Printf("Warning: Found empty sequence entry on line %d", lineCount)
				continue
			}

			for _, charByte := range lineBytes {
				if charByte >= 'a' && charByte <= 'z' {
					charByte -= 32
				}
				if charByte == 'G' || charByte == 'C' {
					gcCount++
					totalBases++
				} else if charByte == 'A' || charByte == 'T' || charByte == 'N' {
					totalBases++
				}
			}
		}
	}

	// Final verification readouts
	logger.Printf("Processing metrics snapshot -> Total Lines parsed: %d", lineCount)
	fmt.Printf("Node %s Processing Results:\n", nodeName)
	fmt.Printf("Total Read Bases: %d | GC Count: %d\n", totalBases, gcCount)
}