# Alchemy Build System - Architecture Documentation

> Generated: 2025-12-25

## Table of Contents
1. [Overview](#overview)
2. [Root Level .mk Files](#root-level-mk-files)
3. [Classes Folder Structure](#classes-folder-structure)
4. [Targets Folder Structure](#targets-folder-structure)
5. [Toolchains Folder Structure](#toolchains-folder-structure)
6. [Include Flow Diagrams](#include-flow-diagrams)
7. [Complete File Reference](#complete-file-reference)

---

## Overview

Alchemy is a GNU Make-based build system for cross-platform software compilation. It supports multiple target operating systems (Linux, Darwin, Windows, eCos, Baremetal) and various build systems (Autotools, CMake, Meson, QMake).

### Statistics

| Category | Count |
|----------|-------|
| Root .mk files | 22 |
| classes/ .mk files | 51 |
| targets/ .mk files | 26 |
| toolchains/ .mk files | 40 |
| Other .mk files | 6 |
| **Total** | **145** |

---

## Root Level .mk Files

### Main Architecture Flow

```mermaid
flowchart TB
    subgraph Entry["🚀 Entry Point"]
        main["main.mk"]
    end

    subgraph Core["📦 Core Definitions"]
        variables["variables.mk<br/>LOCAL_xxx & TARGET_xxx"]
        defs["defs.mk<br/>Utility Macros"]
        clearvars["clearvars.mk<br/>Reset Variables"]
    end

    subgraph Setup["⚙️ Setup Phase"]
        targetsetup["target-setup.mk"]
        toolchainsetup["toolchain-setup.mk"]
        check["check.mk"]
    end

    subgraph Config["🔧 Configuration"]
        configdefs["config-defs.mk"]
        configrules["config-rules.mk"]
    end

    subgraph Classes["📚 Module Classes"]
        classessetup["classes/setup.mk"]
        classesrules["classes/rules.mk"]
    end

    subgraph Output["📤 Output Generation"]
        final["final.mk"]
        image["image.mk"]
        sdk["sdk.mk"]
        symbols["symbols.mk"]
        coverage["coverage.mk"]
        genproject["genproject.mk"]
        gdb["gdb.mk"]
        buildgraph["build-graph.mk"]
        dumpdatabase["dump-database.mk"]
        help["help.mk"]
        properties["properties.mk"]
        osspackages["oss-packages.mk"]
    end

    main --> variables
    main --> defs
    variables --> targetsetup
    defs --> targetsetup
    targetsetup --> toolchainsetup
    toolchainsetup --> check
    check --> classessetup
    classessetup --> configdefs
    configdefs --> configrules
    configrules --> classesrules
    
    classesrules --> final
    classesrules --> image
    classesrules --> sdk
    classesrules --> symbols
    classesrules --> coverage
    classesrules --> genproject
    classesrules --> gdb
    classesrules --> buildgraph
    classesrules --> dumpdatabase
    classesrules --> help
    classesrules --> properties
    classesrules --> osspackages

    style main fill:#e1f5fe,stroke:#0288d1
    style variables fill:#fff3e0,stroke:#f57c00
    style defs fill:#fff3e0,stroke:#f57c00
    style clearvars fill:#fff3e0,stroke:#f57c00
```

### Root .mk Files Relationships

```mermaid
flowchart LR
    subgraph RootMK["Root .mk Files (22 files)"]
        direction TB
        
        subgraph Primary["Primary Files"]
            main["main.mk"]
            envsetup["envsetup.mk"]
        end
        
        subgraph CoreDef["Core Definitions"]
            variables["variables.mk"]
            defs["defs.mk"]
            clearvars["clearvars.mk"]
        end
        
        subgraph SetupFiles["Setup Files"]
            targetsetup["target-setup.mk"]
            toolchainsetup["toolchain-setup.mk"]
        end
        
        subgraph ConfigFiles["Configuration"]
            configdefs["config-defs.mk"]
            configrules["config-rules.mk"]
            check["check.mk"]
        end
        
        subgraph BuildOutput["Build & Output"]
            final["final.mk"]
            image["image.mk"]
            sdk["sdk.mk"]
            symbols["symbols.mk"]
            coverage["coverage.mk"]
            genproject["genproject.mk"]
            gdb["gdb.mk"]
            buildgraph["build-graph.mk"]
            dumpdatabase["dump-database.mk"]
            help["help.mk"]
            properties["properties.mk"]
            osspackages["oss-packages.mk"]
        end
    end

    main -->|"1st"| variables
    main -->|"2nd"| defs
    main -->|"3rd"| targetsetup
    main -->|"4th"| toolchainsetup
    main -->|"5th"| check
    main -->|"6th"| configdefs
    main -->|"7th"| configrules

    envsetup --> targetsetup
```

### Root Files Description Table

| File | Purpose | Dependencies |
|------|---------|--------------|
| `main.mk` | Master orchestrator - includes all files | All other .mk files |
| `variables.mk` | Defines LOCAL_xxx and TARGET_xxx lists | None |
| `defs.mk` | Utility macros (string, paths, etc.) | None |
| `clearvars.mk` | Clears LOCAL_xxx before module | variables.mk |
| `target-setup.mk` | Target OS/architecture detection | targets/setup.mk |
| `toolchain-setup.mk` | Compiler toolchain configuration | toolchains/setup.mk |
| `config-defs.mk` | Configuration system macros | defs.mk |
| `config-rules.mk` | Configuration check/update rules | config-defs.mk |
| `check.mk` | Build validation checks | defs.mk |
| `final.mk` | Final tree generation | All modules built |
| `image.mk` | Filesystem image generation | final.mk |
| `sdk.mk` | SDK generation | All modules |
| `symbols.mk` | Symbol extraction | All modules |
| `coverage.mk` | Code coverage helpers | All modules |
| `genproject.mk` | IDE project generation | All modules |
| `gdb.mk` | GDB debugging helpers | toolchain |
| `build-graph.mk` | Dependency graph generation | All modules |
| `dump-database.mk` | Database export | All modules |
| `help.mk` | Help target | None |
| `properties.mk` | Properties helpers | None |
| `oss-packages.mk` | OSS package helpers | All modules |
| `envsetup.mk` | Environment setup shortcut | target-setup.mk |

---

## Classes Folder Structure

### Classes Overview

```mermaid
flowchart TB
    subgraph ClassesRoot["classes/ (Root Files)"]
        setup["setup.mk<br/>Class Registration"]
        rules["rules.mk<br/>Rules Generation"]
        extra["extra-rules.mk"]
        
        subgraph CodeQuality["Code Quality"]
            codechecksetup["codecheck-setup.mk"]
            codecheckrules["codecheck-rules.mk"]
            codeformatsetup["codeformat-setup.mk"]
            codeformatrules["codeformat-rules.mk"]
        end
        
        subgraph IDE["IDE Integration"]
            genprojectsetup["genproject-setup.mk"]
            genprojectrules["genproject-rules.mk"]
        end
    end

    subgraph BaseClasses["Base Classes"]
        GENERIC["GENERIC/<br/>setup.mk, rules.mk"]
        BINARY["BINARY/<br/>setup.mk, rules.mk"]
    end

    subgraph InternalClasses["Internal Classes (5)"]
        EXECUTABLE["EXECUTABLE/"]
        SHARED_LIBRARY["SHARED_LIBRARY/"]
        STATIC_LIBRARY["STATIC_LIBRARY/"]
        LIBRARY["LIBRARY/"]
        PREBUILT["PREBUILT/"]
    end

    subgraph ExternalClasses["External Classes (11)"]
        AUTOTOOLS["AUTOTOOLS/"]
        CMAKE["CMAKE/"]
        MESON["MESON/"]
        QMAKE["QMAKE/"]
        CUSTOM["CUSTOM/"]
        META_PACKAGE["META_PACKAGE/"]
        LINUX["LINUX/"]
        LINUX_MODULE["LINUX_MODULE/"]
        PYTHON_EXTENSION["PYTHON_EXTENSION/"]
        PYTHON_PACKAGE["PYTHON_PACKAGE/"]
        GI_TYPELIB["GI_TYPELIB/"]
    end

    setup --> GENERIC
    setup --> BINARY
    setup --> codechecksetup
    setup --> codeformatsetup
    setup --> genprojectsetup
    
    GENERIC --> BINARY
    BINARY --> InternalClasses
    GENERIC --> ExternalClasses
```

### Module Class Hierarchy

```mermaid
flowchart TB
    subgraph ClassPattern["Standard Class Pattern"]
        direction LR
        setupmk["setup.mk<br/>(Optional)<br/>Initialize variables"]
        registermk["register.mk<br/>(Required)<br/>Register module"]
        rulesmk["rules.mk<br/>(Required)<br/>Build rules"]
        
        setupmk --> registermk
        registermk --> rulesmk
    end

    subgraph EXECUTABLE_Detail["EXECUTABLE/"]
        exe_register["register.mk"]
        exe_rules["rules.mk"]
    end

    subgraph SHARED_LIBRARY_Detail["SHARED_LIBRARY/"]
        shared_register["register.mk"]
        shared_rules["rules.mk"]
    end

    subgraph STATIC_LIBRARY_Detail["STATIC_LIBRARY/"]
        static_register["register.mk"]
        static_rules["rules.mk"]
    end

    subgraph AUTOTOOLS_Detail["AUTOTOOLS/"]
        auto_setup["setup.mk"]
        auto_register["register.mk"]
        auto_rules["rules.mk"]
    end

    subgraph CMAKE_Detail["CMAKE/"]
        cmake_setup["setup.mk"]
        cmake_register["register.mk"]
        cmake_rules["rules.mk"]
    end

    subgraph LINUX_Detail["LINUX/"]
        linux_register["register.mk"]
        linux_rules["rules.mk"]
        linux_rules_linux["rules-linux.mk"]
        linux_rules_perf["rules-perf.mk"]
        
        linux_rules --> linux_rules_linux
        linux_rules --> linux_rules_perf
    end
```

### All Classes - Complete File Inventory

```mermaid
flowchart TB
    subgraph Classes["classes/ - Complete Structure"]
        subgraph RootFiles["Root Files (9)"]
            r1["setup.mk"]
            r2["rules.mk"]
            r3["extra-rules.mk"]
            r4["codecheck-setup.mk"]
            r5["codecheck-rules.mk"]
            r6["codeformat-setup.mk"]
            r7["codeformat-rules.mk"]
            r8["genproject-setup.mk"]
            r9["genproject-rules.mk"]
        end
        
        subgraph AUTOTOOLS["AUTOTOOLS/ (3)"]
            a1["setup.mk"]
            a2["register.mk"]
            a3["rules.mk"]
        end
        
        subgraph BINARY["BINARY/ (2)"]
            b1["setup.mk"]
            b2["rules.mk"]
        end
        
        subgraph CMAKE["CMAKE/ (3)"]
            c1["setup.mk"]
            c2["register.mk"]
            c3["rules.mk"]
        end
        
        subgraph CUSTOM["CUSTOM/ (2)"]
            cu1["register.mk"]
            cu2["rules.mk"]
        end
        
        subgraph EXECUTABLE["EXECUTABLE/ (2)"]
            e1["register.mk"]
            e2["rules.mk"]
        end
        
        subgraph GENERIC["GENERIC/ (2)"]
            g1["setup.mk"]
            g2["rules.mk"]
        end
        
        subgraph GI_TYPELIB["GI_TYPELIB/ (3)"]
            gi1["setup.mk"]
            gi2["register.mk"]
            gi3["rules.mk"]
        end
        
        subgraph LIBRARY["LIBRARY/ (2)"]
            l1["register.mk"]
            l2["rules.mk"]
        end
        
        subgraph LINUX["LINUX/ (4)"]
            li1["register.mk"]
            li2["rules.mk"]
            li3["rules-linux.mk"]
            li4["rules-perf.mk"]
        end
        
        subgraph LINUX_MODULE["LINUX_MODULE/ (3)"]
            lm1["setup.mk"]
            lm2["register.mk"]
            lm3["rules.mk"]
        end
        
        subgraph MESON["MESON/ (3)"]
            m1["setup.mk"]
            m2["register.mk"]
            m3["rules.mk"]
        end
        
        subgraph META_PACKAGE["META_PACKAGE/ (2)"]
            mp1["register.mk"]
            mp2["rules.mk"]
        end
        
        subgraph PREBUILT["PREBUILT/ (2)"]
            p1["register.mk"]
            p2["rules.mk"]
        end
        
        subgraph PYTHON_EXTENSION["PYTHON_EXTENSION/ (3)"]
            pe1["setup.mk"]
            pe2["register.mk"]
            pe3["rules.mk"]
        end
        
        subgraph PYTHON_PACKAGE["PYTHON_PACKAGE/ (3)"]
            pp1["setup.mk"]
            pp2["register.mk"]
            pp3["rules.mk"]
        end
        
        subgraph QMAKE["QMAKE/ (3)"]
            q1["setup.mk"]
            q2["register.mk"]
            q3["rules.mk"]
        end
        
        subgraph SHARED_LIBRARY["SHARED_LIBRARY/ (2)"]
            sl1["register.mk"]
            sl2["rules.mk"]
        end
        
        subgraph STATIC_LIBRARY["STATIC_LIBRARY/ (2)"]
            st1["register.mk"]
            st2["rules.mk"]
        end
    end
```

### Classes Description Table

| Class | Files | Purpose |
|-------|-------|---------|
| `GENERIC` | setup.mk, rules.mk | Base class for all modules |
| `BINARY` | setup.mk, rules.mk | Binary compilation (C/C++) |
| `EXECUTABLE` | register.mk, rules.mk | Executable programs |
| `SHARED_LIBRARY` | register.mk, rules.mk | Shared libraries (.so) |
| `STATIC_LIBRARY` | register.mk, rules.mk | Static libraries (.a) |
| `LIBRARY` | register.mk, rules.mk | Generic library (auto-detect) |
| `PREBUILT` | register.mk, rules.mk | Prebuilt binaries |
| `AUTOTOOLS` | setup.mk, register.mk, rules.mk | Autotools projects |
| `CMAKE` | setup.mk, register.mk, rules.mk | CMake projects |
| `MESON` | setup.mk, register.mk, rules.mk | Meson projects |
| `QMAKE` | setup.mk, register.mk, rules.mk | Qt/QMake projects |
| `CUSTOM` | register.mk, rules.mk | Custom build scripts |
| `META_PACKAGE` | register.mk, rules.mk | Meta packages (grouping) |
| `LINUX` | register.mk, rules.mk, rules-linux.mk, rules-perf.mk | Linux kernel builds |
| `LINUX_MODULE` | setup.mk, register.mk, rules.mk | Kernel modules |
| `PYTHON_EXTENSION` | setup.mk, register.mk, rules.mk | Python C extensions |
| `PYTHON_PACKAGE` | setup.mk, register.mk, rules.mk | Python packages |
| `GI_TYPELIB` | setup.mk, register.mk, rules.mk | GObject introspection |

---

## Targets Folder Structure

### Targets Overview

```mermaid
flowchart TB
    subgraph TargetsRoot["targets/"]
        setup["setup.mk"]
        packages["packages.mk"]
        nativepkg["native-packages.mk"]
    end

    subgraph Linux["linux/"]
        linux_setup["setup.mk"]
        linux_pkg["packages.mk"]
        
        subgraph LinuxSub["Flavours"]
            native["native/<br/>setup.mk, packages.mk"]
            nativechroot["native-chroot/<br/>setup.mk, packages.mk"]
            android["android/<br/>setup.mk, packages.mk"]
            yocto["yocto/<br/>setup.mk"]
        end
    end

    subgraph Darwin["darwin/"]
        darwin_setup["setup.mk"]
        darwin_pkg["packages.mk"]
        
        subgraph DarwinSub["Flavours"]
            darwin_native["native/<br/>setup.mk, packages.mk"]
            iphoneos["iphoneos/<br/>setup.mk, packages.mk"]
            iphonesim["iphonesimulator/<br/>setup.mk, packages.mk"]
        end
    end

    subgraph Windows["windows/"]
        win_setup["setup.mk"]
        win_pkg["packages.mk"]
    end

    subgraph Baremetal["baremetal/"]
        bare_setup["setup.mk"]
        bare_pkg["packages.mk"]
    end

    subgraph Ecos["ecos/"]
        ecos_setup["setup.mk"]
        ecos_pkg["packages.mk"]
    end

    setup -->|"includes"| linux_setup
    setup -->|"includes"| darwin_setup
    setup -->|"includes"| win_setup
    setup -->|"includes"| bare_setup
    setup -->|"includes"| ecos_setup
    
    packages --> nativepkg
    packages --> linux_pkg
    packages --> darwin_pkg
    packages --> win_pkg
    packages --> bare_pkg
    packages --> ecos_pkg
```

### Targets - Complete File Tree

```mermaid
flowchart LR
    subgraph targets["targets/ (26 .mk files)"]
        subgraph root["Root (3)"]
            t_setup["setup.mk"]
            t_packages["packages.mk"]
            t_native["native-packages.mk"]
        end
        
        subgraph linux["linux/ (11)"]
            l_setup["setup.mk"]
            l_pkg["packages.mk"]
            l_native["native/setup.mk<br/>native/packages.mk"]
            l_chroot["native-chroot/setup.mk<br/>native-chroot/packages.mk"]
            l_android["android/setup.mk<br/>android/packages.mk"]
            l_yocto["yocto/setup.mk"]
        end
        
        subgraph darwin["darwin/ (8)"]
            d_setup["setup.mk"]
            d_pkg["packages.mk"]
            d_native["native/setup.mk<br/>native/packages.mk"]
            d_iphone["iphoneos/setup.mk<br/>iphoneos/packages.mk"]
            d_sim["iphonesimulator/setup.mk<br/>iphonesimulator/packages.mk"]
        end
        
        subgraph windows["windows/ (2)"]
            w_setup["setup.mk"]
            w_pkg["packages.mk"]
        end
        
        subgraph baremetal["baremetal/ (2)"]
            b_setup["setup.mk"]
            b_pkg["packages.mk"]
        end
        
        subgraph ecos["ecos/ (2)"]
            e_setup["setup.mk"]
            e_pkg["packages.mk"]
        end
    end
```

### Targets Description Table

| Target OS | Flavours | Files |
|-----------|----------|-------|
| **linux** | native, native-chroot, android, yocto | 11 .mk files |
| **darwin** | native, iphoneos, iphonesimulator | 8 .mk files |
| **windows** | - | 2 .mk files |
| **baremetal** | - | 2 .mk files |
| **ecos** | - | 2 .mk files |

---

## Toolchains Folder Structure

### Toolchains Overview

```mermaid
flowchart TB
    subgraph ToolchainsRoot["toolchains/"]
        setup["setup.mk<br/>Entry Point"]
        selection["selection.mk<br/>Compiler Selection"]
        flags["flags.mk<br/>Global Flags"]
        warnings["warnings.mk<br/>Warning Flags"]
        cpu["cpu.mk<br/>CPU Detection"]
        libc["libc.mk<br/>C Library"]
        packages["packages.mk<br/>Toolchain Packages"]
    end

    subgraph ArchFlags["Architecture Flags"]
        flags_arm["flags-arm.mk"]
        flags_aarch64["flags-aarch64.mk"]
        flags_x64["flags-x64.mk"]
        flags_x86["flags-x86.mk"]
        flags_avr["flags-avr.mk"]
    end

    subgraph OSToolchains["OS-Specific"]
        linux["linux/"]
        darwin["darwin/"]
        windows["windows/"]
        baremetal["baremetal/"]
        ecos["ecos/"]
    end

    setup --> selection
    setup --> flags
    setup --> warnings
    
    selection --> linux
    selection --> darwin
    selection --> windows
    selection --> baremetal
    selection --> ecos
    
    flags --> flags_arm
    flags --> flags_aarch64
    flags --> flags_x64
    flags --> flags_x86
    flags --> flags_avr
    
    packages --> libc
```

### Toolchains - Complete Structure

```mermaid
flowchart TB
    subgraph toolchains["toolchains/ (40+ .mk files)"]
        subgraph root["Root (12)"]
            tc_setup["setup.mk"]
            tc_selection["selection.mk"]
            tc_flags["flags.mk"]
            tc_warnings["warnings.mk"]
            tc_cpu["cpu.mk"]
            tc_libc["libc.mk"]
            tc_packages["packages.mk"]
            tc_arm["flags-arm.mk"]
            tc_aarch64["flags-aarch64.mk"]
            tc_x64["flags-x64.mk"]
            tc_x86["flags-x86.mk"]
            tc_avr["flags-avr.mk"]
        end
        
        subgraph linux["linux/ (20+)"]
            l_selection["selection.mk"]
            l_flags["flags.mk"]
            l_packages["packages.mk"]
            
            subgraph eglibc["eglibc/"]
                eg_selection["selection.mk"]
                eg_flags["flags.mk"]
                eg_packages["packages.mk"]
            end
            
            subgraph musl["musl/"]
                mu_selection["selection.mk"]
                mu_flags["flags.mk"]
            end
            
            subgraph bionic["bionic/"]
                bi_selection["selection.mk"]
                bi_flags["flags.mk"]
            end
            
            subgraph native["native/"]
                na_selection["selection.mk"]
                na_flags["flags.mk"]
            end
            
            subgraph yocto["yocto/"]
                yo_flags["flags.mk"]
            end
        end
        
        subgraph darwin["darwin/"]
            d_selection["selection.mk"]
            d_flags["flags.mk"]
        end
        
        subgraph windows["windows/"]
            w_selection["selection.mk"]
            w_flags["flags.mk"]
        end
        
        subgraph baremetal["baremetal/"]
            b_selection["selection.mk"]
            b_flags["flags.mk"]
        end
        
        subgraph ecos["ecos/"]
            e_selection["selection.mk"]
            e_flags["flags.mk"]
        end
    end
```

### Toolchain Selection Flow

```mermaid
flowchart TB
    subgraph Input["Input Variables"]
        TARGET_OS["TARGET_OS<br/>(linux, darwin, windows...)"]
        TARGET_ARCH["TARGET_ARCH<br/>(arm, aarch64, x64...)"]
        TARGET_LIBC["TARGET_LIBC<br/>(eglibc, musl, bionic...)"]
        USE_CLANG["USE_CLANG<br/>(0 or 1)"]
    end

    subgraph Selection["toolchains/selection.mk"]
        host_tools["Setup HOST_CC, HOST_CXX..."]
        os_select["Include os/selection.mk"]
        target_tools["Setup TARGET_CC, TARGET_CXX..."]
        
        host_tools --> os_select --> target_tools
    end

    subgraph OSSelection["OS-Specific Selection"]
        linux_sel["linux/selection.mk"]
        darwin_sel["darwin/selection.mk"]
        windows_sel["windows/selection.mk"]
        
        subgraph LinuxLibc["Linux Libc Selection"]
            eglibc_sel["eglibc/selection.mk"]
            musl_sel["musl/selection.mk"]
            bionic_sel["bionic/selection.mk"]
        end
    end

    subgraph Flags["toolchains/flags.mk"]
        global_flags["Global CFLAGS, LDFLAGS"]
        arch_flags["Include flags-arch.mk"]
        os_flags["Include os/flags.mk"]
    end

    subgraph Output["Output Variables"]
        TARGET_CC["TARGET_CC"]
        TARGET_CXX["TARGET_CXX"]
        TARGET_GLOBAL_CFLAGS["TARGET_GLOBAL_CFLAGS"]
        TARGET_GLOBAL_LDFLAGS["TARGET_GLOBAL_LDFLAGS"]
    end

    TARGET_OS --> os_select
    TARGET_ARCH --> arch_flags
    TARGET_LIBC --> LinuxLibc
    USE_CLANG --> host_tools
    USE_CLANG --> target_tools

    Selection --> Flags
    Flags --> Output
```

---

## Include Flow Diagrams

### Main Build Flow Sequence

```mermaid
sequenceDiagram
    participant User as make
    participant Main as main.mk
    participant Vars as variables.mk
    participant Defs as defs.mk
    participant Target as target-setup.mk
    participant TC as toolchain-setup.mk
    participant Classes as classes/
    participant Config as config-*.mk
    participant Scan as atom.mk Scan
    participant Rules as Rules Gen
    participant Output as Output Files

    User->>Main: make [target]
    
    Note over Main: Phase 1: Setup
    Main->>Vars: include variables.mk
    Vars-->>Main: LOCAL_xxx, TARGET_xxx defined
    Main->>Defs: include defs.mk
    Defs-->>Main: Utility macros defined
    
    Note over Main: Phase 2: Target/Toolchain
    Main->>Target: include target-setup.mk
    Target->>Target: include targets/os/setup.mk
    Target-->>Main: TARGET_OS, TARGET_ARCH set
    Main->>TC: include toolchain-setup.mk
    TC->>TC: include selection.mk, flags.mk
    TC-->>Main: CC, CXX, FLAGS set
    
    Note over Main: Phase 3: Classes & Config
    Main->>Classes: include classes/setup.mk
    Classes->>Classes: Setup all module classes
    Classes-->>Main: BUILD_xxx macros defined
    Main->>Config: include config-defs.mk
    Main->>Config: include config-rules.mk
    
    Note over Main: Phase 4: Module Scan
    Main->>Scan: Find all atom.mk files
    Scan-->>Main: USER_MAKEFILES list
    loop Each atom.mk
        Main->>Main: include atom.mk
        Main->>Main: module-add (register)
    end
    
    Note over Main: Phase 5: Rules Generation
    Main->>Rules: include classes/rules.mk
    loop Each Module
        Rules->>Rules: Generate build rules
    end
    
    Note over Main: Phase 6: Output Rules
    Main->>Output: include final.mk, image.mk, sdk.mk...
    
    Main-->>User: Execute requested target
```

### Module Registration Flow

```mermaid
flowchart TB
    subgraph AtomMK["User's atom.mk"]
        step1["LOCAL_PATH := $(call my-dir)"]
        step2["include $(CLEAR_VARS)"]
        step3["LOCAL_MODULE := mymodule<br/>LOCAL_SRC_FILES := ...<br/>LOCAL_LIBRARIES := ..."]
        step4["include $(BUILD_EXECUTABLE)"]
        
        step1 --> step2 --> step3 --> step4
    end

    subgraph ClearVars["clearvars.mk"]
        clear["Clear all LOCAL_xxx variables"]
    end

    subgraph Register["EXECUTABLE/register.mk"]
        validate["Validate LOCAL_xxx"]
        setclass["LOCAL_MODULE_CLASS := EXECUTABLE"]
        moduleadd["$(call module-add)"]
        
        validate --> setclass --> moduleadd
    end

    subgraph Database["Module Database"]
        modules["__modules list"]
        modvars["__modules.mymodule.* variables"]
    end

    step2 --> clear
    step4 --> validate
    moduleadd --> modules
    moduleadd --> modvars
```

### atom.mk Template Flow

```mermaid
flowchart LR
    subgraph Template["atom.mk Structure"]
        path["LOCAL_PATH"]
        clear["CLEAR_VARS"]
        config["Module Config<br/>LOCAL_MODULE<br/>LOCAL_SRC_FILES<br/>LOCAL_LIBRARIES"]
        build["BUILD_xxx"]
    end
    
    path --> clear --> config --> build
    
    subgraph BuildMacros["BUILD_xxx Options"]
        exe["BUILD_EXECUTABLE"]
        shared["BUILD_SHARED_LIBRARY"]
        static["BUILD_STATIC_LIBRARY"]
        auto["BUILD_AUTOTOOLS"]
        cmake["BUILD_CMAKE"]
        meson["BUILD_MESON"]
        custom["BUILD_CUSTOM"]
    end
    
    build --> BuildMacros
```

---

## Complete File Reference

### All .mk Files by Folder

| Folder | File | Purpose |
|--------|------|---------|
| **/** | main.mk | Master orchestrator |
| **/** | variables.mk | Variable definitions |
| **/** | defs.mk | Utility macros |
| **/** | clearvars.mk | Reset LOCAL_xxx |
| **/** | target-setup.mk | Target OS/arch setup |
| **/** | toolchain-setup.mk | Toolchain configuration |
| **/** | config-defs.mk | Config macros |
| **/** | config-rules.mk | Config rules |
| **/** | check.mk | Validation |
| **/** | final.mk | Final tree generation |
| **/** | image.mk | Image generation |
| **/** | sdk.mk | SDK generation |
| **/** | symbols.mk | Symbol extraction |
| **/** | coverage.mk | Code coverage |
| **/** | genproject.mk | IDE project generation |
| **/** | gdb.mk | GDB helpers |
| **/** | build-graph.mk | Dependency graph |
| **/** | dump-database.mk | Database export |
| **/** | help.mk | Help target |
| **/** | properties.mk | Properties helpers |
| **/** | oss-packages.mk | OSS package helpers |
| **/** | envsetup.mk | Environment setup |
| **classes/** | setup.mk | Class registration |
| **classes/** | rules.mk | Rules generation |
| **classes/** | extra-rules.mk | Extra rules |
| **classes/** | codecheck-setup.mk | Code check setup |
| **classes/** | codecheck-rules.mk | Code check rules |
| **classes/** | codeformat-setup.mk | Code format setup |
| **classes/** | codeformat-rules.mk | Code format rules |
| **classes/** | genproject-setup.mk | Project gen setup |
| **classes/** | genproject-rules.mk | Project gen rules |
| **classes/GENERIC/** | setup.mk, rules.mk | Base class |
| **classes/BINARY/** | setup.mk, rules.mk | Binary compilation |
| **classes/EXECUTABLE/** | register.mk, rules.mk | Executable modules |
| **classes/SHARED_LIBRARY/** | register.mk, rules.mk | Shared libraries |
| **classes/STATIC_LIBRARY/** | register.mk, rules.mk | Static libraries |
| **classes/LIBRARY/** | register.mk, rules.mk | Generic library |
| **classes/PREBUILT/** | register.mk, rules.mk | Prebuilt binaries |
| **classes/AUTOTOOLS/** | setup.mk, register.mk, rules.mk | Autotools projects |
| **classes/CMAKE/** | setup.mk, register.mk, rules.mk | CMake projects |
| **classes/MESON/** | setup.mk, register.mk, rules.mk | Meson projects |
| **classes/QMAKE/** | setup.mk, register.mk, rules.mk | Qt/QMake projects |
| **classes/CUSTOM/** | register.mk, rules.mk | Custom build |
| **classes/META_PACKAGE/** | register.mk, rules.mk | Meta packages |
| **classes/LINUX/** | register.mk, rules.mk, rules-linux.mk, rules-perf.mk | Linux kernel |
| **classes/LINUX_MODULE/** | setup.mk, register.mk, rules.mk | Kernel modules |
| **classes/PYTHON_EXTENSION/** | setup.mk, register.mk, rules.mk | Python C extensions |
| **classes/PYTHON_PACKAGE/** | setup.mk, register.mk, rules.mk | Python packages |
| **classes/GI_TYPELIB/** | setup.mk, register.mk, rules.mk | GObject introspection |
| **targets/** | setup.mk, packages.mk, native-packages.mk | Target setup |
| **targets/linux/** | setup.mk, packages.mk | Linux target |
| **targets/linux/native/** | setup.mk, packages.mk | Native Linux |
| **targets/linux/native-chroot/** | setup.mk, packages.mk | Chroot Linux |
| **targets/linux/android/** | setup.mk, packages.mk | Android |
| **targets/linux/yocto/** | setup.mk | Yocto Linux |
| **targets/darwin/** | setup.mk, packages.mk | macOS target |
| **targets/darwin/native/** | setup.mk, packages.mk | Native macOS |
| **targets/darwin/iphoneos/** | setup.mk, packages.mk | iOS |
| **targets/darwin/iphonesimulator/** | setup.mk, packages.mk | iOS Simulator |
| **targets/windows/** | setup.mk, packages.mk | Windows target |
| **targets/baremetal/** | setup.mk, packages.mk | Baremetal |
| **targets/ecos/** | setup.mk, packages.mk | eCos |
| **toolchains/** | setup.mk, selection.mk, flags.mk, warnings.mk, cpu.mk, libc.mk, packages.mk | Toolchain setup |
| **toolchains/** | flags-arm.mk, flags-aarch64.mk, flags-x64.mk, flags-x86.mk, flags-avr.mk | Arch flags |
| **toolchains/linux/** | selection.mk, flags.mk, packages.mk | Linux toolchain |
| **toolchains/linux/eglibc/** | selection.mk, flags.mk, packages.mk | eglibc |
| **toolchains/linux/musl/** | selection.mk, flags.mk | musl |
| **toolchains/linux/bionic/** | selection.mk, flags.mk | Android bionic |
| **toolchains/linux/native/** | selection.mk, flags.mk | Native toolchain |
| **toolchains/linux/yocto/** | flags.mk | Yocto toolchain |
| **toolchains/darwin/** | selection.mk, flags.mk | macOS toolchain |
| **toolchains/windows/** | selection.mk, flags.mk | Windows toolchain |
| **toolchains/baremetal/** | selection.mk, flags.mk | Baremetal toolchain |
| **toolchains/ecos/** | selection.mk, flags.mk | eCos toolchain |
| **packages/helloworld/** | atom.mk | Example package |
| **products/dragonwing-qcs6490/** | setup.mk, product.mk, toolchain-setup.mk | Product config |
| **kconfig/** | atom.mk | Kconfig module |
| **doc/** | python-native-atom.mk | Documentation example |

---

## Key Design Principles

### 1. Separation of Concerns
- **Core definitions** (variables.mk, defs.mk) are isolated from build logic
- **Target setup** is separate from **toolchain setup**
- **Module classes** are self-contained with setup/register/rules pattern

### 2. Hierarchical Organization
- OS-specific code lives in `targets/<os>/` and `toolchains/<os>/`
- Architecture flags are isolated in `flags-<arch>.mk`
- Libc variants have dedicated subfolders

### 3. Extensibility
- New module classes follow the standard pattern
- New targets/toolchains can be added without modifying core files
- Products define their specific configuration in `products/<name>/`

### 4. Build Phases
1. **Setup Phase**: Environment detection and configuration
2. **Scan Phase**: Find all atom.mk modules
3. **Registration Phase**: Build module database
4. **Rules Phase**: Generate make rules
5. **Execution Phase**: Build requested targets

---

## Version Information

- **Alchemy Version**: 1.3.10
- **Documentation Generated**: 2025-12-25
