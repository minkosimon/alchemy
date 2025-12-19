# Architecture Analysis: alchemake.py

## Overview

**alchemake.py** is a sophisticated Make wrapper script that provides **intelligent error detection and early termination** for parallel builds. It solves a common problem: when running `make -jN` (parallel jobs), the first-level Make doesn't immediately stop other jobs when one fails, causing users to wait a long time and scroll through extensive output to find the actual error.

## Core Purpose

```mermaid
flowchart LR
    subgraph Problem["❌ Problem with native make -j"]
        A[make -j8] --> B[Job 1 ✓]
        A --> C[Job 2 ✓]
        A --> D[Job 3 ❌ Error]
        A --> E[Job 4 ✓]
        A --> F[Job 5 ✓]
        A --> G[Job 6 ✓]
        A --> H[Job 7 ✓]
        A --> I[Job 8 ✓]
        D -.->|Error buried in output| J[Hard to find error]
    end
    
    subgraph Solution["✅ Solution with alchemake"]
        K[alchemake] --> L[make -j8]
        L --> M[Job 1 ✓]
        L --> N[Job 2 ✓]
        L --> O[Job 3 ❌]
        O --> P{Error Detected}
        P -->|Kill all jobs| Q[Immediate Stop]
        Q --> R[Clear error message]
    end
```

## Architecture Overview

```mermaid
flowchart TB
    subgraph Main["Main Entry Point"]
        START([Start]) --> SETUP[Setup Logging]
        SETUP --> TTY{Is TTY?}
        TTY -->|No| SIMPLE[Simple subprocess.Popen]
        TTY -->|Yes| JOBCTRL[Initialize JobCtrl]
    end
    
    subgraph JobControl["Job Control System"]
        JOBCTRL --> SIGNALS[Setup Signal Handlers]
        SIGNALS --> LAUNCH[Launch make as Job]
        LAUNCH --> MONITOR[Monitor stderr pipe]
    end
    
    subgraph ErrorDetection["Error Detection Loop"]
        MONITOR --> READ[Read stderr line]
        READ --> EOF{EOF?}
        EOF -->|Yes| WAIT[Wait for process]
        EOF -->|No| CHECK{Error pattern?}
        CHECK -->|No| WRITE[Write to stderr]
        WRITE --> READ
        CHECK -->|Yes| KILL[Kill process tree]
        KILL --> WAIT
    end
    
    subgraph Cleanup["Cleanup & Exit"]
        WAIT --> RESTORE[Restore terminal]
        RESTORE --> EXIT([Exit with make's return code])
    end
    
    SIMPLE --> EXIT
```

## Class Diagram

```mermaid
classDiagram
    class JobCtrl {
        +int tcpgrp
        +bool foreground
        +Job job
        +__init__()
        +signalHandler(signo, frame)
    }
    
    class Job {
        +JobCtrl jobCtrl
        +Process process
        +int pid
        +int pgid
        +int status
        +bool stopped
        +__init__(jobCtrl)
        +_preExec()
        +launch(cmdline, stdin, stdout, stderr, env)
        +kill()
        +updateStatus(status)
    }
    
    JobCtrl "1" --> "1" Job : manages
```

## Signal Handling Flow

```mermaid
sequenceDiagram
    participant User
    participant Alchemake
    participant Make
    participant SubProcesses
    
    User->>Alchemake: Start build
    Alchemake->>Make: Launch in new process group
    Make->>SubProcesses: Spawn parallel jobs
    
    alt Error Detected in stderr
        SubProcesses-->>Make: Error output
        Make-->>Alchemake: Pipe stderr
        Alchemake->>Alchemake: Match error pattern
        Alchemake->>Make: SIGINT
        Alchemake->>SubProcesses: SIGINT (via killpg)
        Alchemake->>SubProcesses: SIGTERM
        Alchemake->>SubProcesses: SIGKILL
        Alchemake->>User: "MAKE ERROR DETECTED"
    end
    
    alt User presses Ctrl+C
        User->>Alchemake: SIGINT
        Alchemake->>Make: Kill process tree
        Alchemake->>SubProcesses: Terminate all
    end
    
    alt User presses Ctrl+Z
        User->>Make: SIGTSTP
        Make-->>Alchemake: SIGCHLD (stopped)
        Alchemake->>Alchemake: Take back terminal
        Alchemake->>Alchemake: Propagate SIGSTOP
    end
```

## Process Group Management

```mermaid
flowchart TB
    subgraph Terminal["Terminal Control"]
        TTY[TTY stdin/stdout]
    end
    
    subgraph ParentGroup["Parent Process Group"]
        SHELL[Shell]
        ALCHEMAKE[alchemake.py]
        SHELL --> ALCHEMAKE
    end
    
    subgraph ChildGroup["Child Process Group (isolated)"]
        MAKE[make]
        CC1[gcc compile 1]
        CC2[gcc compile 2]
        CC3[gcc compile 3]
        LD[linker]
        MAKE --> CC1
        MAKE --> CC2
        MAKE --> CC3
        MAKE --> LD
    end
    
    ALCHEMAKE -->|Launches in new pgid| MAKE
    TTY <-->|tcsetpgrp| ChildGroup
    ALCHEMAKE -->|killpg on error| ChildGroup
    
    style ChildGroup fill:#f9f,stroke:#333,stroke-width:2px
```

## Error Detection Patterns

The script monitors stderr for these regex patterns:

| Pattern | Description |
|---------|-------------|
| `make: \*\*\* No rule to make target .*` | Missing target/dependency |
| `make: \*\*\* \[[^\[\]]*\] Error [0-9]+` | Recipe execution failure |

## Key Features

### 1. **Early Error Termination**
- Scans stderr in real-time for make error patterns
- Immediately kills entire process tree on first error
- Reduces wasted build time significantly

### 2. **Process Group Isolation**
- Child make runs in its own process group (`setpgid(0, 0)`)
- Allows clean termination of all descendant processes
- Prevents killing the wrapper script itself

### 3. **Terminal Control (TTY Handling)**
- Properly manages foreground/background process groups
- Handles `tcsetpgrp` for terminal ownership
- Supports ncurses-based tools (like `make menuconfig`)

### 4. **Signal Propagation**
- `SIGINT/SIGTERM`: Gracefully terminates build
- `SIGTSTP (Ctrl+Z)`: Properly suspends and resumes
- `SIGCONT`: Resumes child processes correctly
- `SIGCHLD`: Monitors child process state changes

### 5. **Graceful Degradation**
- Falls back to simple subprocess if not on TTY
- Works on non-interactive terminals and CI/CD pipelines

## Kill Sequence

```mermaid
flowchart LR
    ERROR[Error Detected] --> WAIT1[Wait 200ms]
    WAIT1 --> INT1[SIGINT to pid]
    INT1 --> WAIT2[Wait 200ms]
    WAIT2 --> INT2[SIGINT to pgid]
    INT2 --> WAIT3[Wait 200ms]
    WAIT3 --> TERM[SIGTERM to pgid]
    TERM --> WAIT4[Wait 200ms]
    WAIT4 --> KILL[SIGKILL to pgid]
    
    style ERROR fill:#f66
    style KILL fill:#f00
```

## Environment Setup

| Variable | Value | Purpose |
|----------|-------|---------|
| `ALCHEMAKE_CMDLINE` | Full command | Debugging/tracing |
| `LC_MESSAGES` | `C` | Force English error messages |
| `LC_TIME` | `C` | Consistent time formatting |

## Source File Reference

- [alchemake.py](../scripts/alchemake.py) - Main script (294 lines)
- [alchemake](../scripts/alchemake) - Shell wrapper
- [alchemake-completion](../scripts/alchemake-completion) - Bash completion

## Constraints & Considerations

1. **Linux-specific**: Heavy use of POSIX signals and process groups
2. **TTY Required**: Full functionality needs interactive terminal
3. **Disk Wait Edge Case**: Cannot interrupt processes in uninterruptible I/O wait
4. **stderr only**: Only stderr is scanned; stdout passes through directly to support ncurses

## Recommendations

- Use `alchemake` instead of raw `make` for parallel builds
- Particularly useful with high `-j` values (e.g., `-j$(nproc)`)
- Works best in interactive terminal sessions
- For CI/CD, still works but with reduced job control features
