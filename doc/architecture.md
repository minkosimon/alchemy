# Alchemy Build System - Architecture Design

## Overview

**Alchemy** is a sophisticated build system inspired by the Android build system, designed to manage complex multi-platform software builds. It combines the simplicity of Android's module-based approach with Buildroot's ability to build open-source packages.

```mermaid
flowchart TB
    subgraph ALCHEMY["🔧 ALCHEMY BUILD SYSTEM v1.3.10"]
        direction TB
        
        subgraph Entry["Phase 1: Entry"]
            A[alchemake<br/>Entry Point] --> B[main.mk<br/>Core]
            B --> C[Module<br/>Discovery]
        end
        
        subgraph Setup["Phase 2: Setup"]
            D[Target<br/>Setup]
            E[Toolchain<br/>Setup]
            F[Module<br/>Classes]
        end
        
        A --> D
        B --> E
        C --> F
        
        D & E & F --> G[Build Rules<br/>Generation]
        
        subgraph Output["Phase 3: Output"]
            G --> H[Staging<br/>Directory]
            H --> I[Final<br/>Directory]
            I --> J[Image<br/>Generation]
        end
    end
    
    style ALCHEMY fill:#1a1a2e,stroke:#e94560,stroke-width:2px
    style Entry fill:#16213e,stroke:#0f3460
    style Setup fill:#16213e,stroke:#0f3460
    style Output fill:#16213e,stroke:#0f3460
```

---

## Directory Structure

```mermaid
flowchart LR
    subgraph Root["📁 alchemy/"]
        direction TB
        
        subgraph Core["Core Makefiles"]
            M1[main.mk]
            M2[defs.mk]
            M3[variables.mk]
            M4[envsetup.mk]
            M5[target-setup.mk]
            M6[toolchain-setup.mk]
        end
        
        subgraph Build["Build Support"]
            B1[check.mk]
            B2[config-defs.mk]
            B3[config-rules.mk]
            B4[image.mk]
            B5[final.mk]
            B6[sdk.mk]
        end
        
        subgraph Dirs["Directories"]
            D1[📁 classes/]
            D2[📁 scripts/]
            D3[📁 targets/]
            D4[📁 toolchains/]
            D5[📁 kconfig/]
            D6[📁 doc/]
        end
    end
    
    style Root fill:#1a1a2e,stroke:#e94560
    style Core fill:#0f3460,stroke:#30363d
    style Build fill:#0f3460,stroke:#30363d
    style Dirs fill:#0f3460,stroke:#30363d
```

### Detailed Structure

| Directory | Purpose |
|-----------|---------|
| `classes/` | Module class definitions (EXECUTABLE, LIBRARY, AUTOTOOLS, CMAKE, etc.) |
| `scripts/` | Build helper scripts (alchemake.py, makefinal.py, mkfs.py, etc.) |
| `targets/` | Target OS configurations (linux, darwin, windows, ecos, baremetal) |
| `toolchains/` | Toolchain configurations and compiler flags |
| `kconfig/` | Configuration system (menuconfig) |
| `doc/` | Documentation files |

---

## Core Components

### 1. Build Entry Points

#### `alchemake` / `alchemake.py`
The main entry point for builds. Wraps GNU Make with:
- Error detection and early termination
- Parallel job management
- Process group handling for clean interruption
- Console control for interactive tools (ncurses)

#### `main.mk`
The core makefile that:
- Defines Alchemy version (1.3.10)
- Sets up build environment
- Scans workspace for `atom.mk` files
- Registers modules
- Generates build rules
- Orchestrates the complete build process

### 2. Module System

Modules are the fundamental building blocks. Each module is defined by an `atom.mk` file using `LOCAL_xxx` variables:

```makefile
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := my-module
LOCAL_SRC_FILES := src/main.c src/utils.c
LOCAL_CFLAGS := -Wall -Werror
LOCAL_LIBRARIES := dependency1 dependency2

include $(BUILD_EXECUTABLE)
```

#### Module Variables (`LOCAL_xxx`)
| Variable | Description |
|----------|-------------|
| `LOCAL_MODULE` | Module name |
| `LOCAL_SRC_FILES` | Source files to compile |
| `LOCAL_CFLAGS` | C compiler flags |
| `LOCAL_CXXFLAGS` | C++ compiler flags |
| `LOCAL_LDFLAGS` | Linker flags |
| `LOCAL_LDLIBS` | Libraries to link |
| `LOCAL_LIBRARIES` | Module dependencies |
| `LOCAL_EXPORT_CFLAGS` | Flags exported to dependents |

### 3. Module Classes

```mermaid
flowchart LR
    subgraph Classes["MODULE CLASSES"]
        direction TB
        
        subgraph Internal["🔨 INTERNAL<br/>Source-based"]
            I1[EXECUTABLE]
            I2[SHARED_LIBRARY]
            I3[STATIC_LIBRARY]
            I4[LIBRARY]
            I5[PREBUILT]
        end
        
        subgraph External["📦 EXTERNAL<br/>Build Systems"]
            E1[AUTOTOOLS]
            E2[CMAKE]
            E3[MESON]
            E4[QMAKE]
            E5[PYTHON_PACKAGE]
            E6[PYTHON_EXTENSION]
            E7[CUSTOM]
            E8[META_PACKAGE]
            E9[LINUX]
            E10[LINUX_MODULE]
            E11[GI_TYPELIB]
        end
    end
    
    style Classes fill:#1a1a2e,stroke:#e94560,stroke-width:2px
    style Internal fill:#16213e,stroke:#3fb950
    style External fill:#16213e,stroke:#d29922
```

### 4. Target Configuration

```mermaid
flowchart TB
    subgraph Config["🎯 TARGET CONFIGURATION"]
        direction LR
        
        subgraph OS["TARGET_OS"]
            OS1[linux]
            OS2[darwin]
            OS3[windows]
            OS4[ecos]
            OS5[baremetal]
        end
        
        subgraph Arch["TARGET_ARCH"]
            A1[arm]
            A2[aarch64]
            A3[x86]
            A4[x64]
        end
        
        subgraph CPU["TARGET_CPU"]
            C1[armv5te]
            C2[armv7a]
            C3[armv7a-neon]
            C4[p6/p6i/p7]
            C5[tegrak1/x1]
        end
        
        subgraph Flavour["TARGET_OS_FLAVOUR"]
            F1[native]
            F2[android]
            F3[parrot]
            F4[yocto]
            F5[iphoneos]
        end
        
        subgraph Libc["TARGET_LIBC"]
            L1[glibc]
            L2[eglibc]
            L3[bionic]
            L4[musl]
            L5[native]
        end
    end
    
    style Config fill:#1a1a2e,stroke:#e94560,stroke-width:2px
    style OS fill:#0f3460,stroke:#ff6b6b
    style Arch fill:#0f3460,stroke:#4ecdc4
    style CPU fill:#0f3460,stroke:#ffe66d
    style Flavour fill:#0f3460,stroke:#95e1d3
    style Libc fill:#0f3460,stroke:#f38181
```

### 5. Build Pipeline

```mermaid
flowchart TB
    subgraph Pipeline["🔄 BUILD PIPELINE"]
        direction TB
        
        subgraph P1["Phase 1: Setup"]
            S1[Environment<br/>Setup] --> S2[Target<br/>Setup] --> S3[Toolchain<br/>Setup]
        end
        
        subgraph P2["Phase 2: Discovery"]
            D1[Scan<br/>atom.mk] --> D2[Register<br/>Modules] --> D3[Resolve<br/>Dependencies]
        end
        
        subgraph P3["Phase 3: Configuration"]
            C1[Load<br/>Kconfig] --> C2[Menu<br/>Config] --> C3[Generate<br/>.config]
        end
        
        subgraph P4["Phase 4: Build"]
            B1[Unpack] --> B2[Patch] --> B3[Configure] --> B4[Build]
        end
        
        subgraph P5["Phase 5: Install"]
            I1[Install<br/>to Stage] --> I2[Staging<br/>Complete] --> I3[Done<br/>Stamp]
        end
        
        subgraph P6["Phase 6: Finalization"]
            F1[Final<br/>Tree] --> F2[Strip<br/>Symbols] --> F3[Image<br/>Generation]
        end
        
        P1 --> P2 --> P3 --> P4 --> P5 --> P6
    end
    
    style Pipeline fill:#1a1a2e,stroke:#e94560,stroke-width:2px
    style P1 fill:#16213e,stroke:#3fb950
    style P2 fill:#16213e,stroke:#58a6ff
    style P3 fill:#16213e,stroke:#d29922
    style P4 fill:#16213e,stroke:#f85149
    style P5 fill:#16213e,stroke:#a371f7
    style P6 fill:#16213e,stroke:#39d353
```

### 6. Output Directory Structure

```mermaid
flowchart TB
    subgraph Output["📂 TARGET_OUT"]
        direction TB
        
        subgraph Build["build/"]
            B1[module1/]
            B2[module2/]
            B1 --> B1a["*.o files"]
            B1 --> B1b["*.d deps"]
            B1 --> B1c["stamps/"]
        end
        
        subgraph Staging["staging/"]
            S1[usr/bin/]
            S2[usr/lib/]
            S3[usr/include/]
            S4[usr/share/]
            S5[etc/]
        end
        
        subgraph Final["final/"]
            F1[usr/]
            F2[etc/]
            F3[lib/]
            F4[boot/]
        end
        
        subgraph Symbols["symbols/"]
            SY1[usr/lib/.debug/]
        end
        
        subgraph Gcov["gcov/"]
            G1[coverage data]
        end
    end
    
    style Output fill:#1a1a2e,stroke:#e94560,stroke-width:2px
    style Build fill:#16213e,stroke:#f0883e
    style Staging fill:#16213e,stroke:#3fb950
    style Final fill:#16213e,stroke:#58a6ff
    style Symbols fill:#16213e,stroke:#d29922
    style Gcov fill:#16213e,stroke:#a371f7
```

---

## Key Features

### Multi-Platform Support
- **Host Systems**: Linux, macOS
- **Target Systems**: Linux, Android, iOS, macOS, Windows, eCos, Baremetal
- **Architectures**: ARM, ARM64, x86, x64, AVR

### Build System Integration
- Native source compilation (C, C++, Fortran)
- GNU Autotools integration
- CMake integration
- Meson integration
- Qt/QMake integration
- Python package support

### Configuration System (kconfig)
- Linux-style configuration
- Menuconfig interface
- Dependencies and constraints
- Automatic configuration validation

### Advanced Features
- Parallel builds with proper error handling
- Incremental builds with dependency tracking
- Cross-compilation support
- SDK generation for external development
- Code coverage (gcov) support
- Debug symbol separation
- Multiple image formats (ext4, ubifs, cpio, tar, plf)

---

## Data Flow Diagram

```mermaid
flowchart TB
    subgraph DataFlow["📊 DATA FLOW"]
        direction TB
        
        A[("📄 atom.mk<br/>modules")] --> B[Scanner]
        B --> C[(Registry<br/>modules)]
        C --> D[Dependency<br/>Resolver]
        D --> A
        
        E[("⚙️ .config<br/>kconfig")] --> F[Config<br/>Processor]
        C --> F
        F --> G[Enabled<br/>Modules]
        
        H[("🔧 Toolchain<br/>Config")] --> I[Rule<br/>Generator]
        G --> I
        I --> J[Build<br/>Execution]
        
        J --> K[(Staging<br/>Directory)]
        J --> L[(Final<br/>Directory)]
        J --> M[(Symbols<br/>Directory)]
        
        L --> N[("💿 Image<br/>.ext4, .ubifs,<br/>.tar, ...")]
        
        K --> O[("📦 SDK<br/>Package")]
    end
    
    style DataFlow fill:#1a1a2e,stroke:#e94560,stroke-width:2px
    style A fill:#0f3460,stroke:#58a6ff
    style E fill:#0f3460,stroke:#3fb950
    style H fill:#0f3460,stroke:#d29922
    style N fill:#16213e,stroke:#f85149
    style O fill:#16213e,stroke:#a371f7
```

---

## Component Interaction

```mermaid
sequenceDiagram
    participant User
    participant alchemake
    participant main.mk
    participant Scanner
    participant Classes
    participant Toolchain
    participant Builder
    
    User->>alchemake: make target
    alchemake->>main.mk: Include & execute
    main.mk->>Scanner: Scan for atom.mk
    Scanner-->>main.mk: Module list
    main.mk->>Classes: Load module classes
    main.mk->>Toolchain: Setup compiler
    
    loop For each module
        main.mk->>Builder: Generate rules
        Builder->>Builder: Compile sources
        Builder->>Builder: Link objects
        Builder-->>main.mk: Module built
    end
    
    main.mk->>Builder: Generate final tree
    Builder->>Builder: Strip symbols
    Builder->>Builder: Create image
    Builder-->>alchemake: Build complete
    alchemake-->>User: Success/Failure
```

---

## Utility Macros (defs.mk)

| Macro | Description |
|-------|-------------|
| `my-dir` | Returns the directory of the current makefile |
| `path-from-top` | Converts absolute path to relative from top |
| `get-define` | Converts string to uppercase with underscores |
| `is-path-absolute` | Checks if path is absolute |
| `streq` / `strneq` | String equality comparison |
| `check-version` | Version comparison |
| `uniq` / `uniq2` | Remove duplicates from list |
| `is-var-defined` | Check if variable is defined |
| `is-item-in-list` | Check if item exists in list |

---

## License

- **Alchemy**: 3-clause BSD License
- **kconfig**: GPLv2 (from Linux kernel)

---

## References

- [Android Build System Documentation](android-build-system.html)
- [Android NDK Build System](android-mk.html)
- [Variables Reference](variables.mk)
- [Main Documentation](alchemy.mkd)
