                             //
                             // segment_2.1 
                             // Loadable segment  [0x0 - 0x91f]
                             // ram:00100000-ram:00100317
                             //
             assume DF = 0x0  (Default)
        00100000 7f 45 4c        Elf64_Ehdr
                 46 02 01 
                 01 00 00 
           00100000 7f              db        7Fh                     e_ident_magi
           00100001 45 4c 46        ds        "ELF"                   e_ident_magi
           00100004 02              db        2h                      e_ident_class
           00100005 01              db        1h                      e_ident_data
           00100006 01              db        1h                      e_ident_vers
           00100007 00              db        0h                      e_ident_osabi
           00100008 00              db        0h                      e_ident_abiv
           00100009 00 00 00 00 00  db[7]                             e_ident_pad
                    00 00
           00100010 03 00           dw        3h                      e_type
           00100012 3e 00           dw        3Eh                     e_machine
           00100014 01 00 00 00     ddw       1h                      e_version
           00100018 a0 11 00 00 00  dq        _start                  e_entry
                    00 00 00
           00100020 40 00 00 00 00  dq        Elf64_Phdr_ARRAY_00100  e_phoff
                    00 00 00
           00100028 70 3a 00 00 00  dq        Elf64_Shdr_ARRAY__elfS  e_shoff
                    00 00 00
           00100030 00 00 00 00     ddw       0h                      e_flags
           00100034 40 00           dw        40h                     e_ehsize
           00100036 38 00           dw        38h                     e_phentsize
           00100038 0d 00           dw        Dh                      e_phnum
           0010003a 40 00           dw        40h                     e_shentsize
           0010003c 1f 00           dw        1Fh                     e_shnum
           0010003e 1e 00           dw        1Eh                     e_shstrndx
                             Elf64_Phdr_ARRAY_00100040                       XREF[2]:     00100020(*), 00100050(*)  
        00100040 06 00 00        Elf64_Ph                                                    PT_PHDR - Program header table
                 00 04 00 
                 00 00 40 
                             //
                             // .interp 
                             // SHT_PROGBITS  [0x318 - 0x333]
                             // ram:00100318-ram:00100333
                             //
                             s_/lib64/ld-linux-x86-64.so.2_00100318          XREF[2]:     00100088(*), 
                                                                                          _elfSectionHeaders::00000050(*)  
        00100318 2f 6c 69        ds         "/lib64/ld-linux-x86-64.so.2"                    Initial Elf program interpreter
                 62 36 34 
                 2f 6c 64 
                             //
                             // .note.gnu.property 
                             // SHT_NOTE  [0x338 - 0x367]
                             // ram:00100338-ram:00100367
                             //
                             NoteGnuProperty_4_00100338                      XREF[3]:     001001d8(*), 00100248(*), 
                                                                                          _elfSectionHeaders::00000090(*)  
        00100338 04 00 00        NoteGnuP                                                    Length of name field
                 00 20 00 
                 00 00 05 
        00100348 02 00 00        NoteGnuP                                                    processor opt 0xc0000002=03 00 0
                 c0 04 00 
                 00 00 03 
        00100354 00 00 00        NoteGnuP                                                    processor opt 0xc0008002=01 00 0
                 00 02 80 
                 00 c0 04 
        00100360 01              ??         01h
        00100361 00              ??         00h
        00100362 00              ??         00h
        00100363 00              ??         00h
        00100364 00              ??         00h
        00100365 00              ??         00h
        00100366 00              ??         00h
        00100367 00              ??         00h
                             //
                             // .note.gnu.build-id 
                             // SHT_NOTE  [0x368 - 0x38b]
                             // ram:00100368-ram:0010038b
                             //
                             GnuBuildId_00100368                             XREF[2]:     00100210(*), 
                                                                                          _elfSectionHeaders::000000d0(*)  
        00100368 04 00 00        GnuBuildId                                                  Length of name field
                 00 14 00 
                 00 00 03 
                             //
                             // .note.ABI-tag 
                             // SHT_NOTE  [0x38c - 0x3ab]
                             // ram:0010038c-ram:001003ab
                             //
                             __abi_tag                                       XREF[1]:     _elfSectionHeaders::00000110(*)  
        0010038c 04 00 00        NoteAbiTag                                                  Length of name field
                 00 10 00 
                 00 00 01 
                             //
                             // .gnu.hash 
                             // SHT_GNU_HASH  [0x3b0 - 0x3df]
                             // ram:001003b0-ram:001003df
                             //
                             __DT_GNU_HASH                                   XREF[2]:     00103df0(*), 
                                                                                          _elfSectionHeaders::00000150(*)  
        001003b0 03 00 00 00     ddw        3h                                               GNU Hash Table - nbucket
        001003b4 10 00 00 00     ddw        10h                                              GNU Hash Table - symbase
        001003b8 01 00 00 00     ddw        1h                                               GNU Hash Table - bloom_size
        001003bc 06 00 00 00     ddw        6h                                               GNU Hash Table - bloom_shift
        001003c0 00 00 a1        dq[1]                                                       GNU Hash Table - bloom
                 00 80 01 
                 10 00
        001003c8 10 00 00        ddw[3]                                                      GNU Hash Table - buckets
                 00 12 00 
                 00 00 00 
        001003d4 28 1d 8c        ddw[3]                                                      GNU Hash Table - chain
                 1c d1 65 
                 ce 6d 67 
                             //
                             // .dynsym 
                             // SHT_DYNSYM  [0x3e0 - 0x5a7]
                             // ram:001003e0-ram:001005a7
                             //
                             __DT_SYMTAB                                     XREF[2]:     00103e10(*), 
                                                                                          _elfSectionHeaders::00000190(*)  
        001003e0 00 00 00        Elf64_Sy
                 00 00 00 
                 00 00 00 
                             //
                             // .dynstr 
                             // SHT_STRTAB  [0x5a8 - 0x6ae]
                             // ram:001005a8-ram:001006ae
                             //
                             __DT_STRTAB                                     XREF[2]:     00103e00(*), 
                                                                                          _elfSectionHeaders::000001d0(*)  
        001005a8 00              ??         00h
        001005a9 5f 5f 63        utf8       u8"__cxa_finalize"
                 78 61 5f 
                 66 69 6e 
        001005b8 66 67 65        utf8       u8"fgets"
                 74 73 00
        001005be 75 73 6c        utf8       u8"usleep"
                 65 65 70 00
        001005c5 5f 5f 6c        utf8       u8"__libc_start_main"
                 69 62 63 
                 5f 73 74 
        001005d7 73 74 72        utf8       u8"strcmp"
                 63 6d 70 00
        001005de 66 6f 70        utf8       u8"fopen"
                 65 6e 00
        001005e4 66 63 6c        utf8       u8"fclose"
                 6f 73 65 00
        001005eb 73 74 64        utf8       u8"stdout"
                 6f 75 74 00
        001005f2 66 66 6c        utf8       u8"fflush"
                 75 73 68 00
        001005f9 73 79 73        utf8       u8"system"
                 74 65 6d 00
        00100600 73 74 72        utf8       u8"strlen"
                 6c 65 6e 00
        00100607 73 74 64        utf8       u8"stdin"
                 69 6e 00
        0010060d 5f 5f 69        utf8       u8"__isoc99_scanf"
                 73 6f 63 
                 39 39 5f 
        0010061c 70 75 74        utf8       u8"putchar"
                 63 68 61 
                 72 00
        00100624 5f 5f 73        utf8       u8"__stack_chk_fail"
                 74 61 63 
                 6b 5f 63 
        00100635 6c 69 62        utf8       u8"libc.so.6"
                 63 2e 73 
                 6f 2e 36 00
        0010063f 47 4c 49        utf8       u8"GLIBC_2.7"
                 42 43 5f 
                 32 2e 37 00
        00100649 47 4c 49        utf8       u8"GLIBC_2.4"
                 42 43 5f 
                 32 2e 34 00
        00100653 47 4c 49        utf8       u8"GLIBC_2.34"
                 42 43 5f 
                 32 2e 33 
        0010065e 47 4c 49        utf8       u8"GLIBC_2.2.5"
                 42 43 5f 
                 32 2e 32 
        0010066a 5f 49 54        utf8       u8"_ITM_deregisterTMCloneTable"
                 4d 5f 64 
                 65 72 65 
        00100686 5f 5f 67        utf8       u8"__gmon_start__"
                 6d 6f 6e 
                 5f 73 74 
        00100695 5f 49 54        utf8       u8"_ITM_registerTMCloneTable"
                 4d 5f 72 
                 65 67 69 
                             //
                             // .gnu.version 
                             // SHT_GNU_versym  [0x6b0 - 0x6d5]
                             // ram:001006b0-ram:001006d5
                             //
                             __DT_VERSYM                                     XREF[2]:     00103f00(*), 
                                                                                          _elfSectionHeaders::00000210(*)  
        001006b0 00 00           dw         0h                                               0
        001006b2 02 00           dw         2h                                               putchar
        001006b4 03 00           dw         3h                                               __libc_start_main
        001006b6 01 00           dw         1h                                               _ITM_deregisterTMCloneTable
        001006b8 02 00           dw         2h                                               fclose
        001006ba 02 00           dw         2h                                               strlen
        001006bc 04 00           dw         4h                                               __stack_chk_fail
        001006be 02 00           dw         2h                                               system
        001006c0 02 00           dw         2h                                               fgets
        001006c2 02 00           dw         2h                                               strcmp
        001006c4 01 00           dw         1h                                               __gmon_start__
        001006c6 02 00           dw         2h                                               fflush
        001006c8 02 00           dw         2h                                               fopen
        001006ca 05 00           dw         5h                                               __isoc99_scanf
        001006cc 01 00           dw         1h                                               _ITM_registerTMCloneTable
        001006ce 02 00           dw         2h                                               usleep
        001006d0 02 00           dw         2h                                               stdout
        001006d2 02 00           dw         2h                                               __cxa_finalize
        001006d4 02 00           dw         2h                                               stdin
                             //
                             // .gnu.version_r 
                             // SHT_GNU_verneed  [0x6d8 - 0x727]
                             // ram:001006d8-ram:00100727
                             //
                             __DT_VERNEED                                    XREF[2]:     00103ee0(*), 
                                                                                          _elfSectionHeaders::00000250(*)  
        001006d8 01              ??         01h
        001006d9 00              ??         00h
        001006da 04              ??         04h
        001006db 00              ??         00h
        001006dc 8d              ??         8Dh
        001006dd 00              ??         00h
        001006de 00              ??         00h                                              ?  ->  00100000
        001006df 00              ??         00h
        001006e0 10              ??         10h
        001006e1 00              ??         00h
        001006e2 00              ??         00h
        001006e3 00              ??         00h
        001006e4 00              ??         00h
        001006e5 00              ??         00h
        001006e6 00              ??         00h
        001006e7 00              ??         00h
        001006e8 17              ??         17h
        001006e9 69              ??         69h    i
        001006ea 69              ??         69h    i
        001006eb 0d              ??         0Dh
        001006ec 00              ??         00h
        001006ed 00              ??         00h
        001006ee 05              ??         05h
        001006ef 00              ??         00h
        001006f0 97              ??         97h
        001006f1 00              ??         00h
        001006f2 00              ??         00h
        001006f3 00              ??         00h
        001006f4 10              ??         10h
        001006f5 00              ??         00h
        001006f6 00              ??         00h
        001006f7 00              ??         00h
        001006f8 14              ??         14h
        001006f9 69              ??         69h    i
        001006fa 69              ??         69h    i
        001006fb 0d              ??         0Dh
        001006fc 00              ??         00h
        001006fd 00              ??         00h
        001006fe 04              ??         04h
        001006ff 00              ??         00h
        00100700 a1              ??         A1h
        00100701 00              ??         00h
        00100702 00              ??         00h
        00100703 00              ??         00h
        00100704 10              ??         10h
        00100705 00              ??         00h
        00100706 00              ??         00h
        00100707 00              ??         00h
        00100708 b4              ??         B4h
        00100709 91              ??         91h
        0010070a 96              ??         96h
        0010070b 06              ??         06h
        0010070c 00              ??         00h
        0010070d 00              ??         00h
        0010070e 03              ??         03h
        0010070f 00              ??         00h
        00100710 ab              ??         ABh
        00100711 00              ??         00h
        00100712 00              ??         00h
        00100713 00              ??         00h
        00100714 10              ??         10h
        00100715 00              ??         00h
        00100716 00              ??         00h
        00100717 00              ??         00h
        00100718 75              ??         75h    u
        00100719 1a              ??         1Ah
        0010071a 69              ??         69h    i
        0010071b 09              ??         09h
        0010071c 00              ??         00h
        0010071d 00              ??         00h
        0010071e 02              ??         02h
        0010071f 00              ??         00h
        00100720 b6              ??         B6h
        00100721 00              ??         00h
        00100722 00              ??         00h
        00100723 00              ??         00h
        00100724 00              ??         00h
        00100725 00              ??         00h
        00100726 00              ??         00h
        00100727 00              ??         00h
                             //
                             // .rela.dyn 
                             // SHT_RELA  [0x728 - 0x817]
                             // ram:00100728-ram:00100817
                             //
                             __DT_RELA                                       XREF[2]:     00103e90(*), 
                                                                                          _elfSectionHeaders::00000290(*)  
        00100728 68 3d 00        Elf64_Re                                                    location to apply the relocation
                 00 00 00 
                 00 00 08 
                             //
                             // .rela.plt 
                             // SHT_RELA  [0x818 - 0x91f]
                             // ram:00100818-ram:0010091f
                             //
                             __DT_JMPREL                                     XREF[2]:     00103e80(*), 
                                                                                          _elfSectionHeaders::000002d0(*)  
        00100818 80 3f 00        Elf64_Re                                                    location to apply the relocation
                 00 00 00 
                 00 00 07 
                             //
                             // .init 
                             // SHT_PROGBITS  [0x1000 - 0x101a]
                             // ram:00101000-ram:0010101a
                             //
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             int __stdcall _init(EVP_PKEY_CTX * ctx)
             int               EAX:4          <RETURN>
             EVP_PKEY_CTX *    RDI:8          ctx
                             __DT_INIT                                       XREF[4]:     Entry Point(*), 001000f8(*), 
                             _init                                                        00103d90(*), 
                                                                                          _elfSectionHeaders::00000310(*)  
        00101000 f3 0f 1e fa     ENDBR64
        00101004 48 83 ec 08     SUB        RSP,0x8
        00101008 48 8b 05        MOV        RAX=><EXTERNAL>::__gmon_start__,qword ptr [-><   = ??
                 d9 2f 00 00                                                                 = 00105048
        0010100f 48 85 c0        TEST       RAX,RAX
        00101012 74 02           JZ         LAB_00101016
        00101014 ff d0           CALL       RAX=><EXTERNAL>::__gmon_start__                  undefined __gmon_start__()
                             LAB_00101016                                    XREF[1]:     00101012(j)  
        00101016 48 83 c4 08     ADD        RSP,0x8
        0010101a c3              RET
                             //
                             // .plt 
                             // SHT_PROGBITS  [0x1020 - 0x10df]
                             // ram:00101020-ram:001010df
                             //
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_00101020()
             undefined         AL:1           <RETURN>
                             FUN_00101020                                    XREF[14]:    00101039(c), 00101049(c), 
                                                                                          00101059(c), 00101069(c), 
                                                                                          00101079(c), 00101089(c), 
                                                                                          00101099(c), 001010a9(c), 
                                                                                          001010b9(c), 001010c9(c), 
                                                                                          001010d9(c), 00102488, 
                                                                                          00102558(*), 
                                                                                          _elfSectionHeaders::00000350(*)  
        00101020 ff 35 4a        PUSH       qword ptr [PTR_00103f70]                         = 00000000
                 2f 00 00
        00101026 f2 ff 25        JMP        qword ptr [PTR_00103f78]
                 4b 2f 00 00
        0010102d 0f              ??         0Fh
        0010102e 1f              ??         1Fh
        0010102f 00              ??         00h
        00101030 f3 0f 1e fa     ENDBR64
        00101034 68 00 00        PUSH       0x0
                 00 00
        00101039 f2 e9 e1        JMP        FUN_00101020                                     undefined FUN_00101020()
                 ff ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
        0010103f 90              NOP
        00101040 f3 0f 1e fa     ENDBR64
        00101044 68 01 00        PUSH       0x1
                 00 00
        00101049 f2 e9 d1        JMP        FUN_00101020                                     undefined FUN_00101020()
                 ff ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
        0010104f 90              NOP
        00101050 f3 0f 1e fa     ENDBR64
        00101054 68 02 00        PUSH       0x2
                 00 00
        00101059 f2 e9 c1        JMP        FUN_00101020                                     undefined FUN_00101020()
                 ff ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
        0010105f 90              NOP
        00101060 f3 0f 1e fa     ENDBR64
        00101064 68 03 00        PUSH       0x3
                 00 00
        00101069 f2 e9 b1        JMP        FUN_00101020                                     undefined FUN_00101020()
                 ff ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
        0010106f 90              NOP
        00101070 f3 0f 1e fa     ENDBR64
        00101074 68 04 00        PUSH       0x4
                 00 00
        00101079 f2 e9 a1        JMP        FUN_00101020                                     undefined FUN_00101020()
                 ff ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
        0010107f 90              NOP
        00101080 f3 0f 1e fa     ENDBR64
        00101084 68 05 00        PUSH       0x5
                 00 00
        00101089 f2 e9 91        JMP        FUN_00101020                                     undefined FUN_00101020()
                 ff ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
        0010108f 90              NOP
        00101090 f3 0f 1e fa     ENDBR64
        00101094 68 06 00        PUSH       0x6
                 00 00
        00101099 f2 e9 81        JMP        FUN_00101020                                     undefined FUN_00101020()
                 ff ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
        0010109f 90              NOP
        001010a0 f3 0f 1e fa     ENDBR64
        001010a4 68 07 00        PUSH       0x7
                 00 00
        001010a9 f2 e9 71        JMP        FUN_00101020                                     undefined FUN_00101020()
                 ff ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
        001010af 90              NOP
        001010b0 f3 0f 1e fa     ENDBR64
        001010b4 68 08 00        PUSH       0x8
                 00 00
        001010b9 f2 e9 61        JMP        FUN_00101020                                     undefined FUN_00101020()
                 ff ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
        001010bf 90              NOP
        001010c0 f3 0f 1e fa     ENDBR64
        001010c4 68 09 00        PUSH       0x9
                 00 00
        001010c9 f2 e9 51        JMP        FUN_00101020                                     undefined FUN_00101020()
                 ff ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
        001010cf 90              NOP
        001010d0 f3 0f 1e fa     ENDBR64
        001010d4 68 0a 00        PUSH       0xa
                 00 00
        001010d9 f2 e9 41        JMP        FUN_00101020                                     undefined FUN_00101020()
                 ff ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
        001010df 90              NOP
                             //
                             // .plt.got 
                             // SHT_PROGBITS  [0x10e0 - 0x10ef]
                             // ram:001010e0-ram:001010ef
                             //
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_001010e0()
             undefined         AL:1           <RETURN>
                             FUN_001010e0                                    XREF[4]:     __do_global_dtors_aux:00101262(c
                                                                                          00102490, 00102580(*), 
                                                                                          _elfSectionHeaders::00000390(*)  
        001010e0 f3 0f 1e fa     ENDBR64
        001010e4 f2 ff 25        JMP        qword ptr [-><EXTERNAL>::__cxa_finalize]         undefined __cxa_finalize()
                 0d 2f 00 00
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        001010eb 0f              ??         0Fh
        001010ec 1f              ??         1Fh
        001010ed 44              ??         44h    D
        001010ee 00              ??         00h
        001010ef 00              ??         00h
                             //
                             // .plt.sec 
                             // SHT_PROGBITS  [0x10f0 - 0x119f]
                             // ram:001010f0-ram:0010119f
                             //
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk int putchar(int __c)
                               Thunked-Function: <EXTERNAL>::putchar
             int               EAX:4          <RETURN>
             int               EDI:4          __c
                             <EXTERNAL>::putchar                             XREF[4]:     type:001015a8(c), 00102498, 
                                                                                          00102598(*), 
                                                                                          _elfSectionHeaders::000003d0(*)  
        001010f0 f3 0f 1e fa     ENDBR64
        001010f4 f2 ff 25        JMP        qword ptr [-><EXTERNAL>::putchar]                int putchar(int __c)
                 85 2e 00 00
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        001010fb 0f              ??         0Fh
        001010fc 1f              ??         1Fh
        001010fd 44              ??         44h    D
        001010fe 00              ??         00h
        001010ff 00              ??         00h
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk int fclose(FILE * __stream)
                               Thunked-Function: <EXTERNAL>::fclose
             int               EAX:4          <RETURN>
             FILE *            RDI:8          __stream
                             <EXTERNAL>::fclose                              XREF[1]:     seven:00101534(c)  
        00101100 f3 0f 1e fa     ENDBR64
        00101104 f2 ff 25        JMP        qword ptr [-><EXTERNAL>::fclose]                 int fclose(FILE * __stream)
                 7d 2e 00 00
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        0010110b 0f              ??         0Fh
        0010110c 1f              ??         1Fh
        0010110d 44              ??         44h    D
        0010110e 00              ??         00h
        0010110f 00              ??         00h
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk size_t strlen(char * __s)
                               Thunked-Function: <EXTERNAL>::strlen
             size_t            RAX:8          <RETURN>
             char *            RDI:8          __s
                             <EXTERNAL>::strlen                              XREF[1]:     type:001015dc(c)  
        00101110 f3 0f 1e fa     ENDBR64
        00101114 f2 ff 25        JMP        qword ptr [-><EXTERNAL>::strlen]                 size_t strlen(char * __s)
                 75 2e 00 00
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        0010111b 0f              ??         0Fh
        0010111c 1f              ??         1Fh
        0010111d 44              ??         44h    D
        0010111e 00              ??         00h
        0010111f 00              ??         00h
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk noreturn undefined __stack_chk_fail()
                               Thunked-Function: <EXTERNAL>::__stack_chk
             undefined         AL:1           <RETURN>
                             <EXTERNAL>::__stack_chk_fail                    XREF[12]:    loop:00101483(c), 
                                                                                          seven:00101572(c), 
                                                                                          zero:001016a2(c), 
                                                                                          one:0010175d(c), two:00101818(c), 
                                                                                          three:001018d3(c), 
                                                                                          four:0010198e(c), 
                                                                                          five:00101a49(c), 
                                                                                          six:00101b04(c), 
                                                                                          eight:00101bbf(c), 
                                                                                          nine:00101c7a(c), 
                                                                                          ten:00101d35(c)  
        00101120 f3 0f 1e fa     ENDBR64
        00101124 f2 ff 25        JMP        qword ptr [-><EXTERNAL>::__stack_chk_fail]       undefined __stack_chk_fail()
                 6d 2e 00 00
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        0010112b 0f              ??         0Fh
        0010112c 1f              ??         1Fh
        0010112d 44              ??         44h    D
        0010112e 00              ??         00h
        0010112f 00              ??         00h
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk int system(char * __command)
                               Thunked-Function: <EXTERNAL>::system
             int               EAX:4          <RETURN>
             char *            RDI:8          __command
                             <EXTERNAL>::system                              XREF[13]:    loop:0010145b(c), 
                                                                                          seven:00101519(c), 
                                                                                          seven:0010154a(c), 
                                                                                          zero:0010167a(c), 
                                                                                          one:00101735(c), two:001017f0(c), 
                                                                                          three:001018ab(c), 
                                                                                          four:00101966(c), 
                                                                                          five:00101a21(c), 
                                                                                          six:00101adc(c), 
                                                                                          eight:00101b97(c), 
                                                                                          nine:00101c52(c), 
                                                                                          ten:00101d0d(c)  
        00101130 f3 0f 1e fa     ENDBR64
        00101134 f2 ff 25        JMP        qword ptr [-><EXTERNAL>::system]                 int system(char * __command)
                 65 2e 00 00
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        0010113b 0f              ??         0Fh
        0010113c 1f              ??         1Fh
        0010113d 44              ??         44h    D
        0010113e 00              ??         00h
        0010113f 00              ??         00h
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk char * fgets(char * __s, int __n, FILE * __stream)
                               Thunked-Function: <EXTERNAL>::fgets
             char *            RAX:8          <RETURN>
             char *            RDI:8          __s
             int               ESI:4          __n
             FILE *            RDX:8          __stream
                             <EXTERNAL>::fgets                               XREF[1]:     seven:001014fc(c)  
        00101140 f3 0f 1e fa     ENDBR64
        00101144 f2 ff 25        JMP        qword ptr [-><EXTERNAL>::fgets]                  char * fgets(char * __s, int __n
                 5d 2e 00 00
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        0010114b 0f              ??         0Fh
        0010114c 1f              ??         1Fh
        0010114d 44              ??         44h    D
        0010114e 00              ??         00h
        0010114f 00              ??         00h
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk int strcmp(char * __s1, char * __s2)
                               Thunked-Function: <EXTERNAL>::strcmp
             int               EAX:4          <RETURN>
             char *            RDI:8          __s1
             char *            RSI:8          __s2
                             <EXTERNAL>::strcmp                              XREF[10]:    zero:0010165b(c), 
                                                                                          one:00101716(c), two:001017d1(c), 
                                                                                          three:0010188c(c), 
                                                                                          four:00101947(c), 
                                                                                          five:00101a02(c), 
                                                                                          six:00101abd(c), 
                                                                                          eight:00101b78(c), 
                                                                                          nine:00101c33(c), 
                                                                                          ten:00101cee(c)  
        00101150 f3 0f 1e fa     ENDBR64
        00101154 f2 ff 25        JMP        qword ptr [-><EXTERNAL>::strcmp]                 int strcmp(char * __s1, char * _
                 55 2e 00 00
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        0010115b 0f              ??         0Fh
        0010115c 1f              ??         1Fh
        0010115d 44              ??         44h    D
        0010115e 00              ??         00h
        0010115f 00              ??         00h
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk int fflush(FILE * __stream)
                               Thunked-Function: <EXTERNAL>::fflush
             int               EAX:4          <RETURN>
             FILE *            RDI:8          __stream
                             <EXTERNAL>::fflush                              XREF[12]:    loop:001012fb(c), 
                                                                                          type:001015b7(c), 
                                                                                          zero:00101613(c), 
                                                                                          one:001016ce(c), two:00101789(c), 
                                                                                          three:00101844(c), 
                                                                                          four:001018ff(c), 
                                                                                          five:001019ba(c), 
                                                                                          six:00101a75(c), 
                                                                                          eight:00101b30(c), 
                                                                                          nine:00101beb(c), 
                                                                                          ten:00101ca6(c)  
        00101160 f3 0f 1e fa     ENDBR64
        00101164 f2 ff 25        JMP        qword ptr [-><EXTERNAL>::fflush]                 int fflush(FILE * __stream)
                 4d 2e 00 00
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        0010116b 0f              ??         0Fh
        0010116c 1f              ??         1Fh
        0010116d 44              ??         44h    D
        0010116e 00              ??         00h
        0010116f 00              ??         00h
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk FILE * fopen(char * __filename, char * __modes)
                               Thunked-Function: <EXTERNAL>::fopen
             FILE *            RAX:8          <RETURN>
             char *            RDI:8          __filename
             char *            RSI:8          __modes
                             <EXTERNAL>::fopen                               XREF[1]:     seven:001014cd(c)  
        00101170 f3 0f 1e fa     ENDBR64
        00101174 f2 ff 25        JMP        qword ptr [-><EXTERNAL>::fopen]                  FILE * fopen(char * __filename, 
                 45 2e 00 00
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        0010117b 0f              ??         0Fh
        0010117c 1f              ??         1Fh
        0010117d 44              ??         44h    D
        0010117e 00              ??         00h
        0010117f 00              ??         00h
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk undefined __isoc99_scanf()
                               Thunked-Function: <EXTERNAL>::__isoc99_sc
             undefined         AL:1           <RETURN>
                             <EXTERNAL>::__isoc99_scanf                      XREF[11]:    loop:00101320(c), 
                                                                                          zero:0010163d(c), 
                                                                                          one:001016f8(c), two:001017b3(c), 
                                                                                          three:0010186e(c), 
                                                                                          four:00101929(c), 
                                                                                          five:001019e4(c), 
                                                                                          six:00101a9f(c), 
                                                                                          eight:00101b5a(c), 
                                                                                          nine:00101c15(c), 
                                                                                          ten:00101cd0(c)  
        00101180 f3 0f 1e fa     ENDBR64
        00101184 f2 ff 25        JMP        qword ptr [-><EXTERNAL>::__isoc99_scanf]         undefined __isoc99_scanf()
                 3d 2e 00 00
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        0010118b 0f              ??         0Fh
        0010118c 1f              ??         1Fh
        0010118d 44              ??         44h    D
        0010118e 00              ??         00h
        0010118f 00              ??         00h
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk int usleep(__useconds_t __useconds)
                               Thunked-Function: <EXTERNAL>::usleep
             int               EAX:4          <RETURN>
             __useconds_t      EDI:4          __useconds
                             <EXTERNAL>::usleep                              XREF[1]:     type:001015c6(c)  
        00101190 f3 0f 1e fa     ENDBR64
        00101194 f2 ff 25        JMP        qword ptr [-><EXTERNAL>::usleep]                 int usleep(__useconds_t __usecon
                 35 2e 00 00
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        0010119b 0f              ??         0Fh
        0010119c 1f              ??         1Fh
        0010119d 44              ??         44h    D
        0010119e 00              ??         00h
        0010119f 00              ??         00h
                             //
                             // .text 
                             // SHT_PROGBITS  [0x11a0 - 0x1dbe]
                             // ram:001011a0-ram:00101dbe
                             //
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined processEntry _start()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[1]:     001011b2(*)  
                             _start                                          XREF[5]:     Entry Point(*), 00100018(*), 
                                                                                          001024a0, 00102540(*), 
                                                                                          _elfSectionHeaders::00000410(*)  
        001011a0 f3 0f 1e fa     ENDBR64
        001011a4 31 ed           XOR        EBP,EBP
        001011a6 49 89 d1        MOV        R9,RDX
        001011a9 5e              POP        RSI
        001011aa 48 89 e2        MOV        RDX,RSP
        001011ad 48 83 e4 f0     AND        RSP,-0x10
        001011b1 50              PUSH       RAX
        001011b2 54              PUSH       RSP=>local_10
        001011b3 45 31 c0        XOR        R8D,R8D
        001011b6 31 c9           XOR        ECX,ECX
        001011b8 48 8d 3d        LEA        RDI,[main]
                 ca 00 00 00
        001011bf ff 15 13        CALL       qword ptr [-><EXTERNAL>::__libc_start_main]      undefined __libc_start_main()
                 2e 00 00                                                                    = 00105008
        001011c5 f4              HLT
        001011c6 66              ??         66h    f
        001011c7 2e              ??         2Eh    .
        001011c8 0f              ??         0Fh
        001011c9 1f              ??         1Fh
        001011ca 84              ??         84h
        001011cb 00              ??         00h
        001011cc 00              ??         00h
        001011cd 00              ??         00h
        001011ce 00              ??         00h
        001011cf 00              ??         00h
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined deregister_tm_clones()
             undefined         AL:1           <RETURN>
                             deregister_tm_clones                            XREF[1]:     __do_global_dtors_aux:00101267(c
        001011d0 48 8d 3d        LEA        RDI,[__TMC_END__]
                 41 2e 00 00
        001011d7 48 8d 05        LEA        RAX,[__TMC_END__]
                 3a 2e 00 00
        001011de 48 39 f8        CMP        RAX,RDI
        001011e1 74 15           JZ         LAB_001011f8
        001011e3 48 8b 05        MOV        RAX=><EXTERNAL>::_ITM_deregisterTMCloneTable,q   = ??
                 f6 2d 00 00                                                                 = 00105010
        001011ea 48 85 c0        TEST       RAX,RAX
        001011ed 74 09           JZ         LAB_001011f8
        001011ef ff e0           JMP        RAX=><EXTERNAL>::_ITM_deregisterTMCloneTable     undefined _ITM_deregisterTMClone
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        001011f1 0f              ??         0Fh
        001011f2 1f              ??         1Fh
        001011f3 80              ??         80h
        001011f4 00              ??         00h
        001011f5 00              ??         00h
        001011f6 00              ??         00h
        001011f7 00              ??         00h
                             LAB_001011f8                                    XREF[2]:     001011e1(j), 001011ed(j)  
        001011f8 c3              RET
        001011f9 0f              ??         0Fh
        001011fa 1f              ??         1Fh
        001011fb 80              ??         80h
        001011fc 00              ??         00h
        001011fd 00              ??         00h
        001011fe 00              ??         00h
        001011ff 00              ??         00h
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined register_tm_clones()
             undefined         AL:1           <RETURN>
                             register_tm_clones                              XREF[1]:     frame_dummy:00101280(T), 
                                                                                          frame_dummy:00101284(c)  
        00101200 48 8d 3d        LEA        RDI,[__TMC_END__]
                 11 2e 00 00
        00101207 48 8d 35        LEA        RSI,[__TMC_END__]
                 0a 2e 00 00
        0010120e 48 29 fe        SUB        RSI,RDI
        00101211 48 89 f0        MOV        RAX,RSI
        00101214 48 c1 ee 3f     SHR        RSI,0x3f
        00101218 48 c1 f8 03     SAR        RAX,0x3
        0010121c 48 01 c6        ADD        RSI,RAX
        0010121f 48 d1 fe        SAR        RSI,0x1
        00101222 74 14           JZ         LAB_00101238
        00101224 48 8b 05        MOV        RAX=><EXTERNAL>::_ITM_registerTMCloneTable,qwo   = ??
                 c5 2d 00 00                                                                 = 00105068
        0010122b 48 85 c0        TEST       RAX,RAX
        0010122e 74 08           JZ         LAB_00101238
        00101230 ff e0           JMP        RAX=><EXTERNAL>::_ITM_registerTMCloneTable       undefined _ITM_registerTMCloneTa
                             -- Flow Override: CALL_RETURN (COMPUTED_CALL_TERMINATOR)
        00101232 66              ??         66h    f
        00101233 0f              ??         0Fh
        00101234 1f              ??         1Fh
        00101235 44              ??         44h    D
        00101236 00              ??         00h
        00101237 00              ??         00h
                             LAB_00101238                                    XREF[2]:     00101222(j), 0010122e(j)  
        00101238 c3              RET
        00101239 0f              ??         0Fh
        0010123a 1f              ??         1Fh
        0010123b 80              ??         80h
        0010123c 00              ??         00h
        0010123d 00              ??         00h
        0010123e 00              ??         00h
        0010123f 00              ??         00h
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined __do_global_dtors_aux()
             undefined         AL:1           <RETURN>
                             __do_global_dtors_aux                           XREF[2]:     Entry Point(*), 00103d70(*)  
        00101240 f3 0f 1e fa     ENDBR64
        00101244 80 3d ed        CMP        byte ptr [completed.0],0x0
                 2d 00 00 00
        0010124b 75 2b           JNZ        LAB_00101278
        0010124d 55              PUSH       RBP
        0010124e 48 83 3d        CMP        qword ptr [-><EXTERNAL>::__cxa_finalize],0x0     = 00105078
                 a2 2d 00 
                 00 00
        00101256 48 89 e5        MOV        RBP,RSP
        00101259 74 0c           JZ         LAB_00101267
        0010125b 48 8b 3d        MOV        RDI,qword ptr [->__dso_handle]                   = 00104008
                 a6 2d 00 00
        00101262 e8 79 fe        CALL       FUN_001010e0                                     undefined FUN_001010e0()
                 ff ff
                             LAB_00101267                                    XREF[1]:     00101259(j)  
        00101267 e8 64 ff        CALL       deregister_tm_clones                             undefined deregister_tm_clones()
                 ff ff
        0010126c c6 05 c5        MOV        byte ptr [completed.0],0x1
                 2d 00 00 01
        00101273 5d              POP        RBP
        00101274 c3              RET
        00101275 0f              ??         0Fh
        00101276 1f              ??         1Fh
        00101277 00              ??         00h
                             LAB_00101278                                    XREF[1]:     0010124b(j)  
        00101278 c3              RET
        00101279 0f              ??         0Fh
        0010127a 1f              ??         1Fh
        0010127b 80              ??         80h
        0010127c 00              ??         00h
        0010127d 00              ??         00h
        0010127e 00              ??         00h
        0010127f 00              ??         00h
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk undefined frame_dummy()
                               Thunked-Function: register_tm_clones
             undefined         AL:1           <RETURN>
                             frame_dummy                                     XREF[2]:     Entry Point(*), 00103d68(*)  
        00101280 f3 0f 1e fa     ENDBR64
        00101284 e9 77 ff        JMP        register_tm_clones                               undefined register_tm_clones()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined main()
             undefined         AL:1           <RETURN>
             undefined4        Stack[-0xc]:4  local_c                                 XREF[3]:     001012a4(W), 
                                                                                                   001012bf(W), 
                                                                                                   001012c2(R)  
                             main                                            XREF[4]:     Entry Point(*), 
                                                                                          _start:001011b8(*), 001024a8, 
                                                                                          001025b0(*)  
        00101289 f3 0f 1e fa     ENDBR64
        0010128d 55              PUSH       RBP
        0010128e 48 89 e5        MOV        RBP,RSP
        00101291 48 83 ec 10     SUB        RSP,0x10
        00101295 48 8d 05        LEA        RAX,[s_Welcome_doomed_investigator_00102008]     = "Welcome doomed investigator\n"
                 6c 0d 00 00
        0010129c 48 89 c7        MOV        RDI=>s_Welcome_doomed_investigator_00102008,RAX  = "Welcome doomed investigator\n"
        0010129f e8 d5 02        CALL       type                                             undefined type()
                 00 00
        001012a4 c7 45 fc        MOV        dword ptr [RBP + local_c],0x1
                 01 00 00 00
        001012ab eb 15           JMP        LAB_001012c2
                             LAB_001012ad                                    XREF[1]:     001012c6(j)  
        001012ad b8 00 00        MOV        EAX,0x0
                 00 00
        001012b2 e8 18 00        CALL       loop                                             undefined loop()
                 00 00
        001012b7 85 c0           TEST       EAX,EAX
        001012b9 0f 94 c0        SETZ       AL
        001012bc 0f b6 c0        MOVZX      EAX,AL
        001012bf 89 45 fc        MOV        dword ptr [RBP + local_c],EAX
                             LAB_001012c2                                    XREF[1]:     001012ab(j)  
        001012c2 83 7d fc 00     CMP        dword ptr [RBP + local_c],0x0
        001012c6 75 e5           JNZ        LAB_001012ad
        001012c8 b8 00 00        MOV        EAX,0x0
                 00 00
        001012cd c9              LEAVE
        001012ce c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined loop()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     001012e4(W), 
                                                                                                   00101474(R)  
             undefined4        Stack[-0x14]:4 local_14                                XREF[3]:     001012ea(W), 
                                                                                                   0010130a(*), 
                                                                                                   00101325(R)  
                             loop                                            XREF[4]:     Entry Point(*), main:001012b2(c), 
                                                                                          001024b0, 001025d0(*)  
        001012cf f3 0f 1e fa     ENDBR64
        001012d3 55              PUSH       RBP
        001012d4 48 89 e5        MOV        RBP,RSP
        001012d7 48 83 ec 10     SUB        RSP,0x10
        001012db 64 48 8b        MOV        RAX,qword ptr FS:[0x28]
                 04 25 28 
                 00 00 00
        001012e4 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
        001012e8 31 c0           XOR        EAX,EAX
        001012ea c7 45 f4        MOV        dword ptr [RBP + local_14],0x0
                 00 00 00 00
        001012f1 48 8b 05        MOV        RAX,qword ptr [stdin]
                 38 2d 00 00
        001012f8 48 89 c7        MOV        RDI,RAX
        001012fb e8 60 fe        CALL       <EXTERNAL>::fflush                               int fflush(FILE * __stream)
                 ff ff
        00101300 b8 00 00        MOV        EAX,0x0
                 00 00
        00101305 e8 32 0a        CALL       eleven                                           undefined eleven()
                 00 00
        0010130a 48 8d 45 f4     LEA        RAX=>local_14,[RBP + -0xc]
        0010130e 48 89 c6        MOV        RSI,RAX
        00101311 48 8d 05        LEA        RAX,[DAT_00102025]                               = 25h    %
                 0d 0d 00 00
        00101318 48 89 c7        MOV        RDI=>DAT_00102025,RAX                            = 25h    %
        0010131b b8 00 00        MOV        EAX,0x0
                 00 00
        00101320 e8 5b fe        CALL       <EXTERNAL>::__isoc99_scanf                       undefined __isoc99_scanf()
                 ff ff
        00101325 8b 45 f4        MOV        EAX,dword ptr [RBP + local_14]
        00101328 3d ff ff        CMP        EAX,0xffff
                 00 00
        0010132d 0f 84 12        JZ         LAB_00101445
                 01 00 00
        00101333 3d ff ff        CMP        EAX,0xffff
                 00 00
        00101338 0f 8f 13        JG         LAB_00101451
                 01 00 00
        0010133e 3d 60 5d        CMP        EAX,0x5d60
                 00 00
        00101343 0f 84 f0        JZ         LAB_00101439
                 00 00 00
        00101349 3d 60 5d        CMP        EAX,0x5d60
                 00 00
        0010134e 0f 8f fd        JG         LAB_00101451
                 00 00 00
        00101354 3d 31 19        CMP        EAX,0x1931
                 00 00
        00101359 0f 84 ce        JZ         LAB_0010142d
                 00 00 00
        0010135f 3d 31 19        CMP        EAX,0x1931
                 00 00
        00101364 0f 8f e7        JG         LAB_00101451
                 00 00 00
        0010136a 3d ab 0c        CMP        EAX,0xcab
                 00 00
        0010136f 0f 84 ac        JZ         LAB_00101421
                 00 00 00
        00101375 3d ab 0c        CMP        EAX,0xcab
                 00 00
        0010137a 0f 8f d1        JG         LAB_00101451
                 00 00 00
        00101380 3d 73 0c        CMP        EAX,0xc73
                 00 00
        00101385 0f 84 8a        JZ         LAB_00101415
                 00 00 00
        0010138b 3d 73 0c        CMP        EAX,0xc73
                 00 00
        00101390 0f 8f bb        JG         LAB_00101451
                 00 00 00
        00101396 3d 1f 02        CMP        EAX,0x21f
                 00 00
        0010139b 74 6c           JZ         LAB_00101409
        0010139d 3d 1f 02        CMP        EAX,0x21f
                 00 00
        001013a2 0f 8f a9        JG         LAB_00101451
                 00 00 00
        001013a8 3d 26 01        CMP        EAX,0x126
                 00 00
        001013ad 74 4e           JZ         LAB_001013fd
        001013af 3d 26 01        CMP        EAX,0x126
                 00 00
        001013b4 0f 8f 97        JG         LAB_00101451
                 00 00 00
        001013ba 83 f8 7c        CMP        EAX,0x7c
        001013bd 74 32           JZ         LAB_001013f1
        001013bf 83 f8 7c        CMP        EAX,0x7c
        001013c2 0f 8f 89        JG         LAB_00101451
                 00 00 00
        001013c8 85 c0           TEST       EAX,EAX
        001013ca 74 07           JZ         LAB_001013d3
        001013cc 83 f8 1c        CMP        EAX,0x1c
        001013cf 74 11           JZ         LAB_001013e2
        001013d1 eb 7e           JMP        LAB_00101451
                             LAB_001013d3                                    XREF[1]:     001013ca(j)  
        001013d3 b8 00 00        MOV        EAX,0x0
                 00 00
        001013d8 e8 11 02        CALL       zero                                             undefined zero()
                 00 00
        001013dd e9 92 00        JMP        LAB_00101474
                 00 00
                             LAB_001013e2                                    XREF[1]:     001013cf(j)  
        001013e2 b8 00 00        MOV        EAX,0x0
                 00 00
        001013e7 e8 bd 02        CALL       one                                              undefined one()
                 00 00
        001013ec e9 83 00        JMP        LAB_00101474
                 00 00
                             LAB_001013f1                                    XREF[1]:     001013bd(j)  
        001013f1 b8 00 00        MOV        EAX,0x0
                 00 00
        001013f6 e8 69 03        CALL       two                                              undefined two()
                 00 00
        001013fb eb 77           JMP        LAB_00101474
                             LAB_001013fd                                    XREF[1]:     001013ad(j)  
        001013fd b8 00 00        MOV        EAX,0x0
                 00 00
        00101402 e8 18 04        CALL       three                                            undefined three()
                 00 00
        00101407 eb 6b           JMP        LAB_00101474
                             LAB_00101409                                    XREF[1]:     0010139b(j)  
        00101409 b8 00 00        MOV        EAX,0x0
                 00 00
        0010140e e8 c7 04        CALL       four                                             undefined four()
                 00 00
        00101413 eb 5f           JMP        LAB_00101474
                             LAB_00101415                                    XREF[1]:     00101385(j)  
        00101415 b8 00 00        MOV        EAX,0x0
                 00 00
        0010141a e8 76 05        CALL       five                                             undefined five()
                 00 00
        0010141f eb 53           JMP        LAB_00101474
                             LAB_00101421                                    XREF[1]:     0010136f(j)  
        00101421 b8 00 00        MOV        EAX,0x0
                 00 00
        00101426 e8 25 06        CALL       six                                              undefined six()
                 00 00
        0010142b eb 47           JMP        LAB_00101474
                             LAB_0010142d                                    XREF[1]:     00101359(j)  
        0010142d b8 00 00        MOV        EAX,0x0
                 00 00
        00101432 e8 d4 06        CALL       eight                                            undefined eight()
                 00 00
        00101437 eb 3b           JMP        LAB_00101474
                             LAB_00101439                                    XREF[1]:     00101343(j)  
        00101439 b8 00 00        MOV        EAX,0x0
                 00 00
        0010143e e8 83 07        CALL       nine                                             undefined nine()
                 00 00
        00101443 eb 2f           JMP        LAB_00101474
                             LAB_00101445                                    XREF[1]:     0010132d(j)  
        00101445 b8 00 00        MOV        EAX,0x0
                 00 00
        0010144a e8 32 08        CALL       ten                                              undefined ten()
                 00 00
        0010144f eb 23           JMP        LAB_00101474
                             LAB_00101451                                    XREF[9]:     00101338(j), 0010134e(j), 
                                                                                          00101364(j), 0010137a(j), 
                                                                                          00101390(j), 001013a2(j), 
                                                                                          001013b4(j), 001013c2(j), 
                                                                                          001013d1(j)  
        00101451 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 d0 0b 00 00
        00101458 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        0010145b e8 d0 fc        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        00101460 48 8d 05        LEA        RAX,[s_There_seems_to_have_been_a_mix_u_001020   = "There seems to have been a mi
                 c9 0b 00 00
        00101467 48 89 c7        MOV        RDI=>s_There_seems_to_have_been_a_mix_u_001020   = "There seems to have been a mi
        0010146a e8 0a 01        CALL       type                                             undefined type()
                 00 00
        0010146f b8 00 00        MOV        EAX,0x0
                 00 00
                             LAB_00101474                                    XREF[10]:    001013dd(j), 001013ec(j), 
                                                                                          001013fb(j), 00101407(j), 
                                                                                          00101413(j), 0010141f(j), 
                                                                                          0010142b(j), 00101437(j), 
                                                                                          00101443(j), 0010144f(j)  
        00101474 48 8b 55 f8     MOV        RDX,qword ptr [RBP + local_10]
        00101478 64 48 2b        SUB        RDX,qword ptr FS:[0x28]
                 14 25 28 
                 00 00 00
        00101481 74 05           JZ         LAB_00101488
        00101483 e8 98 fc        CALL       <EXTERNAL>::__stack_chk_fail                     undefined __stack_chk_fail()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             LAB_00101488                                    XREF[1]:     00101481(j)  
        00101488 c9              LEAVE
        00101489 c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined seven()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     001014a4(W), 
                                                                                                   00101563(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[2]:     001014f0(*), 
                                                                                                   00101501(*)  
             undefined8        Stack[-0x30]:8 local_30                                XREF[4]:     001014d2(W), 
                                                                                                   001014d6(R), 
                                                                                                   001014ec(R), 
                                                                                                   0010152d(R)  
             undefined1        Stack[-0x3c]:1 local_3c                                XREF[2]:     00101498(W), 
                                                                                                   001014aa(R)  
                             seven                                           XREF[13]:    Entry Point(*), zero:00101669(c), 
                                                                                          one:00101724(c), two:001017df(c), 
                                                                                          three:0010189a(c), 
                                                                                          four:00101955(c), 
                                                                                          five:00101a10(c), 
                                                                                          six:00101acb(c), 
                                                                                          eight:00101b86(c), 
                                                                                          nine:00101c41(c), 
                                                                                          ten:00101cfc(c), 001024b8, 
                                                                                          001025f0(*)  
        0010148a f3 0f 1e fa     ENDBR64
        0010148e 55              PUSH       RBP
        0010148f 48 89 e5        MOV        RBP,RSP
        00101492 48 83 ec 40     SUB        RSP,0x40
        00101496 89 f8           MOV        EAX,EDI
        00101498 88 45 cc        MOV        byte ptr [RBP + local_3c],AL
        0010149b 64 48 8b        MOV        RAX,qword ptr FS:[0x28]
                 04 25 28 
                 00 00 00
        001014a4 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
        001014a8 31 c0           XOR        EAX,EAX
        001014aa 0f b6 45 cc     MOVZX      EAX,byte ptr [RBP + local_3c]
        001014ae 83 f0 01        XOR        EAX,0x1
        001014b1 84 c0           TEST       AL,AL
        001014b3 0f 84 87        JZ         LAB_00101540
                 00 00 00
        001014b9 48 8d 05        LEA        RAX,[DAT_001020ab]                               = 72h    r
                 eb 0b 00 00
        001014c0 48 89 c6        MOV        RSI=>DAT_001020ab,RAX                            = 72h    r
        001014c3 48 8d 05        LEA        RAX,[s_/root/token.txt_001020ad]                 = "/root/token.txt"
                 e3 0b 00 00
        001014ca 48 89 c7        MOV        RDI=>s_/root/token.txt_001020ad,RAX              = "/root/token.txt"
        001014cd e8 9e fc        CALL       <EXTERNAL>::fopen                                FILE * fopen(char * __filename, 
                 ff ff
        001014d2 48 89 45 d8     MOV        qword ptr [RBP + local_30],RAX
        001014d6 48 83 7d        CMP        qword ptr [RBP + local_30],0x0
                 d8 00
        001014db 74 32           JZ         LAB_0010150f
        001014dd 48 8d 05        LEA        RAX,[s_You_go_to_the_correct_ride_and_u_001020   = "You go to the correct ride an
                 dc 0b 00 00
        001014e4 48 89 c7        MOV        RDI=>s_You_go_to_the_correct_ride_and_u_001020   = "You go to the correct ride an
        001014e7 e8 8d 00        CALL       type                                             undefined type()
                 00 00
        001014ec 48 8b 55 d8     MOV        RDX,qword ptr [RBP + local_30]
        001014f0 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        001014f4 be 14 00        MOV        ESI,0x14
                 00 00
        001014f9 48 89 c7        MOV        RDI,RAX
        001014fc e8 3f fc        CALL       <EXTERNAL>::fgets                                char * fgets(char * __s, int __n
                 ff ff
        00101501 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101505 48 89 c7        MOV        RDI,RAX
        00101508 e8 6c 00        CALL       type                                             undefined type()
                 00 00
        0010150d eb 1e           JMP        LAB_0010152d
                             LAB_0010150f                                    XREF[1]:     001014db(j)  
        0010150f 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 12 0b 00 00
        00101516 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        00101519 e8 12 fc        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        0010151e 48 8d 05        LEA        RAX,[s_Error_opening_file_-_do_you_have_001021   = "Error opening file - do you h
                 23 0c 00 00
        00101525 48 89 c7        MOV        RDI=>s_Error_opening_file_-_do_you_have_001021   = "Error opening file - do you h
        00101528 e8 4c 00        CALL       type                                             undefined type()
                 00 00
                             LAB_0010152d                                    XREF[1]:     0010150d(j)  
        0010152d 48 8b 45 d8     MOV        RAX,qword ptr [RBP + local_30]
        00101531 48 89 c7        MOV        RDI,RAX
        00101534 e8 c7 fb        CALL       <EXTERNAL>::fclose                               int fclose(FILE * __stream)
                 ff ff
        00101539 b8 01 00        MOV        EAX,0x1
                 00 00
        0010153e eb 23           JMP        LAB_00101563
                             LAB_00101540                                    XREF[1]:     001014b3(j)  
        00101540 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 e1 0a 00 00
        00101547 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        0010154a e8 e1 fb        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        0010154f 48 8d 05        LEA        RAX,[s_There_seems_to_have_been_a_mix_u_001021   = "There seems to have been a mi
                 4a 0c 00 00
        00101556 48 89 c7        MOV        RDI=>s_There_seems_to_have_been_a_mix_u_001021   = "There seems to have been a mi
        00101559 e8 1b 00        CALL       type                                             undefined type()
                 00 00
        0010155e b8 00 00        MOV        EAX,0x0
                 00 00
                             LAB_00101563                                    XREF[1]:     0010153e(j)  
        00101563 48 8b 55 f8     MOV        RDX,qword ptr [RBP + local_10]
        00101567 64 48 2b        SUB        RDX,qword ptr FS:[0x28]
                 14 25 28 
                 00 00 00
        00101570 74 05           JZ         LAB_00101577
        00101572 e8 a9 fb        CALL       <EXTERNAL>::__stack_chk_fail                     undefined __stack_chk_fail()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             LAB_00101577                                    XREF[1]:     00101570(j)  
        00101577 c9              LEAVE
        00101578 c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined type()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[1]:     001015e8(R)  
             undefined4        Stack[-0x1c]:4 local_1c                                XREF[4]:     0010158a(W), 
                                                                                                   00101593(R), 
                                                                                                   001015cb(RW), 
                                                                                                   001015cf(R)  
             undefined8        Stack[-0x30]:8 local_30                                XREF[3]:     00101586(W), 
                                                                                                   00101599(R), 
                                                                                                   001015d5(R)  
                             type                                            XREF[37]:    Entry Point(*), main:0010129f(c), 
                                                                                          loop:0010146a(c), 
                                                                                          seven:001014e7(c), 
                                                                                          seven:00101508(c), 
                                                                                          seven:00101528(c), 
                                                                                          seven:00101559(c), 
                                                                                          zero:00101622(c), 
                                                                                          zero:00101689(c), 
                                                                                          one:001016dd(c), one:00101744(c), 
                                                                                          two:00101798(c), two:001017ff(c), 
                                                                                          three:00101853(c), 
                                                                                          three:001018ba(c), 
                                                                                          four:0010190e(c), 
                                                                                          four:00101975(c), 
                                                                                          five:001019c9(c), 
                                                                                          five:00101a30(c), 001024c0, [more]
        00101579 f3 0f 1e fa     ENDBR64
        0010157d 55              PUSH       RBP
        0010157e 48 89 e5        MOV        RBP,RSP
        00101581 53              PUSH       RBX
        00101582 48 83 ec 28     SUB        RSP,0x28
        00101586 48 89 7d d8     MOV        qword ptr [RBP + local_30],RDI
        0010158a c7 45 ec        MOV        dword ptr [RBP + local_1c],0x0
                 00 00 00 00
        00101591 eb 3c           JMP        LAB_001015cf
                             LAB_00101593                                    XREF[1]:     001015e4(j)  
        00101593 8b 45 ec        MOV        EAX,dword ptr [RBP + local_1c]
        00101596 48 63 d0        MOVSXD     RDX,EAX
        00101599 48 8b 45 d8     MOV        RAX,qword ptr [RBP + local_30]
        0010159d 48 01 d0        ADD        RAX,RDX
        001015a0 0f b6 00        MOVZX      EAX,byte ptr [RAX]
        001015a3 0f be c0        MOVSX      EAX,AL
        001015a6 89 c7           MOV        EDI,EAX
        001015a8 e8 43 fb        CALL       <EXTERNAL>::putchar                              int putchar(int __c)
                 ff ff
        001015ad 48 8b 05        MOV        RAX,qword ptr [stdout]
                 6c 2a 00 00
        001015b4 48 89 c7        MOV        RDI,RAX
        001015b7 e8 a4 fb        CALL       <EXTERNAL>::fflush                               int fflush(FILE * __stream)
                 ff ff
        001015bc bf 20 4e        MOV        EDI,0x4e20
                 00 00
        001015c1 b8 00 00        MOV        EAX,0x0
                 00 00
        001015c6 e8 c5 fb        CALL       <EXTERNAL>::usleep                               int usleep(__useconds_t __usecon
                 ff ff
        001015cb 83 45 ec 01     ADD        dword ptr [RBP + local_1c],0x1
                             LAB_001015cf                                    XREF[1]:     00101591(j)  
        001015cf 8b 45 ec        MOV        EAX,dword ptr [RBP + local_1c]
        001015d2 48 63 d8        MOVSXD     RBX,EAX
        001015d5 48 8b 45 d8     MOV        RAX,qword ptr [RBP + local_30]
        001015d9 48 89 c7        MOV        RDI,RAX
        001015dc e8 2f fb        CALL       <EXTERNAL>::strlen                               size_t strlen(char * __s)
                 ff ff
        001015e1 48 39 c3        CMP        RBX,RAX
        001015e4 72 ad           JC         LAB_00101593
        001015e6 90              NOP
        001015e7 90              NOP
        001015e8 48 8b 5d f8     MOV        RBX,qword ptr [RBP + local_10]
        001015ec c9              LEAVE
        001015ed c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined zero()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     00101603(W), 
                                                                                                   00101693(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[2]:     00101627(*), 
                                                                                                   00101651(*)  
             undefined8        Stack[-0x30]:8 local_30                                XREF[2]:     00101649(W), 
                                                                                                   0010164d(R)  
                             zero                                            XREF[4]:     Entry Point(*), loop:001013d8(c), 
                                                                                          001024c8, 00102634(*)  
        001015ee f3 0f 1e fa     ENDBR64
        001015f2 55              PUSH       RBP
        001015f3 48 89 e5        MOV        RBP,RSP
        001015f6 48 83 ec 30     SUB        RSP,0x30
        001015fa 64 48 8b        MOV        RAX,qword ptr FS:[0x28]
                 04 25 28 
                 00 00 00
        00101603 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
        00101607 31 c0           XOR        EAX,EAX
        00101609 48 8b 05        MOV        RAX,qword ptr [stdin]
                 20 2a 00 00
        00101610 48 89 c7        MOV        RDI,RAX
        00101613 e8 48 fb        CALL       <EXTERNAL>::fflush                               int fflush(FILE * __stream)
                 ff ff
        00101618 48 8d 05        LEA        RAX,[s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
                 39 0c 00 00
        0010161f 48 89 c7        MOV        RDI=>s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
        00101622 e8 52 ff        CALL       type                                             undefined type()
                 ff ff
        00101627 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        0010162b 48 89 c6        MOV        RSI,RAX
        0010162e 48 8d 05        LEA        RAX,[DAT_00102280]                               = 25h    %
                 4b 0c 00 00
        00101635 48 89 c7        MOV        RDI=>DAT_00102280,RAX                            = 25h    %
        00101638 b8 00 00        MOV        EAX,0x0
                 00 00
        0010163d e8 3e fb        CALL       <EXTERNAL>::__isoc99_scanf                       undefined __isoc99_scanf()
                 ff ff
        00101642 48 8d 05        LEA        RAX,[password]                                   = "pge2j"
                 c7 29 00 00
        00101649 48 89 45 d8     MOV        qword ptr [RBP + local_30],RAX=>password         = "pge2j"
        0010164d 48 8b 55 d8     MOV        RDX=>password,qword ptr [RBP + local_30]         = "pge2j"
        00101651 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101655 48 89 d6        MOV        RSI=>password,RDX                                = "pge2j"
        00101658 48 89 c7        MOV        RDI,RAX
        0010165b e8 f0 fa        CALL       <EXTERNAL>::strcmp                               int strcmp(char * __s1, char * _
                 ff ff
        00101660 85 c0           TEST       EAX,EAX
        00101662 75 0c           JNZ        LAB_00101670
        00101664 bf 01 00        MOV        EDI,0x1
                 00 00
        00101669 e8 1c fe        CALL       seven                                            undefined seven()
                 ff ff
        0010166e eb 23           JMP        LAB_00101693
                             LAB_00101670                                    XREF[1]:     00101662(j)  
        00101670 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 b1 09 00 00
        00101677 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        0010167a e8 b1 fa        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        0010167f 48 8d 05        LEA        RAX,[s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
                 02 0c 00 00
        00101686 48 89 c7        MOV        RDI=>s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
        00101689 e8 eb fe        CALL       type                                             undefined type()
                 ff ff
        0010168e b8 00 00        MOV        EAX,0x0
                 00 00
                             LAB_00101693                                    XREF[1]:     0010166e(j)  
        00101693 48 8b 55 f8     MOV        RDX,qword ptr [RBP + local_10]
        00101697 64 48 2b        SUB        RDX,qword ptr FS:[0x28]
                 14 25 28 
                 00 00 00
        001016a0 74 05           JZ         LAB_001016a7
        001016a2 e8 79 fa        CALL       <EXTERNAL>::__stack_chk_fail                     undefined __stack_chk_fail()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             LAB_001016a7                                    XREF[1]:     001016a0(j)  
        001016a7 c9              LEAVE
        001016a8 c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined one()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     001016be(W), 
                                                                                                   0010174e(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[2]:     001016e2(*), 
                                                                                                   0010170c(*)  
             undefined8        Stack[-0x30]:8 local_30                                XREF[2]:     00101704(W), 
                                                                                                   00101708(R)  
                             one                                             XREF[4]:     Entry Point(*), loop:001013e7(c), 
                                                                                          001024d0, 00102654(*)  
        001016a9 f3 0f 1e fa     ENDBR64
        001016ad 55              PUSH       RBP
        001016ae 48 89 e5        MOV        RBP,RSP
        001016b1 48 83 ec 30     SUB        RSP,0x30
        001016b5 64 48 8b        MOV        RAX,qword ptr FS:[0x28]
                 04 25 28 
                 00 00 00
        001016be 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
        001016c2 31 c0           XOR        EAX,EAX
        001016c4 48 8b 05        MOV        RAX,qword ptr [stdin]
                 65 29 00 00
        001016cb 48 89 c7        MOV        RDI,RAX
        001016ce e8 8d fa        CALL       <EXTERNAL>::fflush                               int fflush(FILE * __stream)
                 ff ff
        001016d3 48 8d 05        LEA        RAX,[s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
                 7e 0b 00 00
        001016da 48 89 c7        MOV        RDI=>s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
        001016dd e8 97 fe        CALL       type                                             undefined type()
                 ff ff
        001016e2 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        001016e6 48 89 c6        MOV        RSI,RAX
        001016e9 48 8d 05        LEA        RAX,[DAT_00102280]                               = 25h    %
                 90 0b 00 00
        001016f0 48 89 c7        MOV        RDI=>DAT_00102280,RAX                            = 25h    %
        001016f3 b8 00 00        MOV        EAX,0x0
                 00 00
        001016f8 e8 83 fa        CALL       <EXTERNAL>::__isoc99_scanf                       undefined __isoc99_scanf()
                 ff ff
        001016fd 48 8d 05        LEA        RAX,[password]                                   = "pge2j"
                 0c 29 00 00
        00101704 48 89 45 d8     MOV        qword ptr [RBP + local_30],RAX=>password         = "pge2j"
        00101708 48 8b 55 d8     MOV        RDX=>password,qword ptr [RBP + local_30]         = "pge2j"
        0010170c 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101710 48 89 d6        MOV        RSI=>password,RDX                                = "pge2j"
        00101713 48 89 c7        MOV        RDI,RAX
        00101716 e8 35 fa        CALL       <EXTERNAL>::strcmp                               int strcmp(char * __s1, char * _
                 ff ff
        0010171b 85 c0           TEST       EAX,EAX
        0010171d 75 0c           JNZ        LAB_0010172b
        0010171f bf 01 00        MOV        EDI,0x1
                 00 00
        00101724 e8 61 fd        CALL       seven                                            undefined seven()
                 ff ff
        00101729 eb 23           JMP        LAB_0010174e
                             LAB_0010172b                                    XREF[1]:     0010171d(j)  
        0010172b 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 f6 08 00 00
        00101732 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        00101735 e8 f6 f9        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        0010173a 48 8d 05        LEA        RAX,[s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
                 47 0b 00 00
        00101741 48 89 c7        MOV        RDI=>s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
        00101744 e8 30 fe        CALL       type                                             undefined type()
                 ff ff
        00101749 b8 00 00        MOV        EAX,0x0
                 00 00
                             LAB_0010174e                                    XREF[1]:     00101729(j)  
        0010174e 48 8b 55 f8     MOV        RDX,qword ptr [RBP + local_10]
        00101752 64 48 2b        SUB        RDX,qword ptr FS:[0x28]
                 14 25 28 
                 00 00 00
        0010175b 74 05           JZ         LAB_00101762
        0010175d e8 be f9        CALL       <EXTERNAL>::__stack_chk_fail                     undefined __stack_chk_fail()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             LAB_00101762                                    XREF[1]:     0010175b(j)  
        00101762 c9              LEAVE
        00101763 c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined two()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     00101779(W), 
                                                                                                   00101809(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[2]:     0010179d(*), 
                                                                                                   001017c7(*)  
             undefined8        Stack[-0x30]:8 local_30                                XREF[2]:     001017bf(W), 
                                                                                                   001017c3(R)  
                             two                                             XREF[4]:     Entry Point(*), loop:001013f6(c), 
                                                                                          001024d8, 00102674(*)  
        00101764 f3 0f 1e fa     ENDBR64
        00101768 55              PUSH       RBP
        00101769 48 89 e5        MOV        RBP,RSP
        0010176c 48 83 ec 30     SUB        RSP,0x30
        00101770 64 48 8b        MOV        RAX,qword ptr FS:[0x28]
                 04 25 28 
                 00 00 00
        00101779 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
        0010177d 31 c0           XOR        EAX,EAX
        0010177f 48 8b 05        MOV        RAX,qword ptr [stdin]
                 aa 28 00 00
        00101786 48 89 c7        MOV        RDI,RAX
        00101789 e8 d2 f9        CALL       <EXTERNAL>::fflush                               int fflush(FILE * __stream)
                 ff ff
        0010178e 48 8d 05        LEA        RAX,[s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
                 c3 0a 00 00
        00101795 48 89 c7        MOV        RDI=>s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
        00101798 e8 dc fd        CALL       type                                             undefined type()
                 ff ff
        0010179d 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        001017a1 48 89 c6        MOV        RSI,RAX
        001017a4 48 8d 05        LEA        RAX,[DAT_00102280]                               = 25h    %
                 d5 0a 00 00
        001017ab 48 89 c7        MOV        RDI=>DAT_00102280,RAX                            = 25h    %
        001017ae b8 00 00        MOV        EAX,0x0
                 00 00
        001017b3 e8 c8 f9        CALL       <EXTERNAL>::__isoc99_scanf                       undefined __isoc99_scanf()
                 ff ff
        001017b8 48 8d 05        LEA        RAX,[password]                                   = "pge2j"
                 51 28 00 00
        001017bf 48 89 45 d8     MOV        qword ptr [RBP + local_30],RAX=>password         = "pge2j"
        001017c3 48 8b 55 d8     MOV        RDX=>password,qword ptr [RBP + local_30]         = "pge2j"
        001017c7 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        001017cb 48 89 d6        MOV        RSI=>password,RDX                                = "pge2j"
        001017ce 48 89 c7        MOV        RDI,RAX
        001017d1 e8 7a f9        CALL       <EXTERNAL>::strcmp                               int strcmp(char * __s1, char * _
                 ff ff
        001017d6 85 c0           TEST       EAX,EAX
        001017d8 75 0c           JNZ        LAB_001017e6
        001017da bf 01 00        MOV        EDI,0x1
                 00 00
        001017df e8 a6 fc        CALL       seven                                            undefined seven()
                 ff ff
        001017e4 eb 23           JMP        LAB_00101809
                             LAB_001017e6                                    XREF[1]:     001017d8(j)  
        001017e6 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 3b 08 00 00
        001017ed 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        001017f0 e8 3b f9        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        001017f5 48 8d 05        LEA        RAX,[s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
                 8c 0a 00 00
        001017fc 48 89 c7        MOV        RDI=>s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
        001017ff e8 75 fd        CALL       type                                             undefined type()
                 ff ff
        00101804 b8 00 00        MOV        EAX,0x0
                 00 00
                             LAB_00101809                                    XREF[1]:     001017e4(j)  
        00101809 48 8b 55 f8     MOV        RDX,qword ptr [RBP + local_10]
        0010180d 64 48 2b        SUB        RDX,qword ptr FS:[0x28]
                 14 25 28 
                 00 00 00
        00101816 74 05           JZ         LAB_0010181d
        00101818 e8 03 f9        CALL       <EXTERNAL>::__stack_chk_fail                     undefined __stack_chk_fail()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             LAB_0010181d                                    XREF[1]:     00101816(j)  
        0010181d c9              LEAVE
        0010181e c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined three()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     00101834(W), 
                                                                                                   001018c4(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[2]:     00101858(*), 
                                                                                                   00101882(*)  
             undefined8        Stack[-0x30]:8 local_30                                XREF[2]:     0010187a(W), 
                                                                                                   0010187e(R)  
                             three                                           XREF[4]:     Entry Point(*), loop:00101402(c), 
                                                                                          001024e0, 00102694(*)  
        0010181f f3 0f 1e fa     ENDBR64
        00101823 55              PUSH       RBP
        00101824 48 89 e5        MOV        RBP,RSP
        00101827 48 83 ec 30     SUB        RSP,0x30
        0010182b 64 48 8b        MOV        RAX,qword ptr FS:[0x28]
                 04 25 28 
                 00 00 00
        00101834 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
        00101838 31 c0           XOR        EAX,EAX
        0010183a 48 8b 05        MOV        RAX,qword ptr [stdin]
                 ef 27 00 00
        00101841 48 89 c7        MOV        RDI,RAX
        00101844 e8 17 f9        CALL       <EXTERNAL>::fflush                               int fflush(FILE * __stream)
                 ff ff
        00101849 48 8d 05        LEA        RAX,[s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
                 08 0a 00 00
        00101850 48 89 c7        MOV        RDI=>s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
        00101853 e8 21 fd        CALL       type                                             undefined type()
                 ff ff
        00101858 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        0010185c 48 89 c6        MOV        RSI,RAX
        0010185f 48 8d 05        LEA        RAX,[DAT_00102280]                               = 25h    %
                 1a 0a 00 00
        00101866 48 89 c7        MOV        RDI=>DAT_00102280,RAX                            = 25h    %
        00101869 b8 00 00        MOV        EAX,0x0
                 00 00
        0010186e e8 0d f9        CALL       <EXTERNAL>::__isoc99_scanf                       undefined __isoc99_scanf()
                 ff ff
        00101873 48 8d 05        LEA        RAX,[password]                                   = "pge2j"
                 96 27 00 00
        0010187a 48 89 45 d8     MOV        qword ptr [RBP + local_30],RAX=>password         = "pge2j"
        0010187e 48 8b 55 d8     MOV        RDX=>password,qword ptr [RBP + local_30]         = "pge2j"
        00101882 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101886 48 89 d6        MOV        RSI=>password,RDX                                = "pge2j"
        00101889 48 89 c7        MOV        RDI,RAX
        0010188c e8 bf f8        CALL       <EXTERNAL>::strcmp                               int strcmp(char * __s1, char * _
                 ff ff
        00101891 85 c0           TEST       EAX,EAX
        00101893 75 0c           JNZ        LAB_001018a1
        00101895 bf 00 00        MOV        EDI,0x0
                 00 00
        0010189a e8 eb fb        CALL       seven                                            undefined seven()
                 ff ff
        0010189f eb 23           JMP        LAB_001018c4
                             LAB_001018a1                                    XREF[1]:     00101893(j)  
        001018a1 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 80 07 00 00
        001018a8 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        001018ab e8 80 f8        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        001018b0 48 8d 05        LEA        RAX,[s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
                 d1 09 00 00
        001018b7 48 89 c7        MOV        RDI=>s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
        001018ba e8 ba fc        CALL       type                                             undefined type()
                 ff ff
        001018bf b8 00 00        MOV        EAX,0x0
                 00 00
                             LAB_001018c4                                    XREF[1]:     0010189f(j)  
        001018c4 48 8b 55 f8     MOV        RDX,qword ptr [RBP + local_10]
        001018c8 64 48 2b        SUB        RDX,qword ptr FS:[0x28]
                 14 25 28 
                 00 00 00
        001018d1 74 05           JZ         LAB_001018d8
        001018d3 e8 48 f8        CALL       <EXTERNAL>::__stack_chk_fail                     undefined __stack_chk_fail()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             LAB_001018d8                                    XREF[1]:     001018d1(j)  
        001018d8 c9              LEAVE
        001018d9 c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined four()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     001018ef(W), 
                                                                                                   0010197f(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[2]:     00101913(*), 
                                                                                                   0010193d(*)  
             undefined8        Stack[-0x30]:8 local_30                                XREF[2]:     00101935(W), 
                                                                                                   00101939(R)  
                             four                                            XREF[4]:     Entry Point(*), loop:0010140e(c), 
                                                                                          001024e8, 001026b4(*)  
        001018da f3 0f 1e fa     ENDBR64
        001018de 55              PUSH       RBP
        001018df 48 89 e5        MOV        RBP,RSP
        001018e2 48 83 ec 30     SUB        RSP,0x30
        001018e6 64 48 8b        MOV        RAX,qword ptr FS:[0x28]
                 04 25 28 
                 00 00 00
        001018ef 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
        001018f3 31 c0           XOR        EAX,EAX
        001018f5 48 8b 05        MOV        RAX,qword ptr [stdin]
                 34 27 00 00
        001018fc 48 89 c7        MOV        RDI,RAX
        001018ff e8 5c f8        CALL       <EXTERNAL>::fflush                               int fflush(FILE * __stream)
                 ff ff
        00101904 48 8d 05        LEA        RAX,[s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
                 4d 09 00 00
        0010190b 48 89 c7        MOV        RDI=>s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
        0010190e e8 66 fc        CALL       type                                             undefined type()
                 ff ff
        00101913 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101917 48 89 c6        MOV        RSI,RAX
        0010191a 48 8d 05        LEA        RAX,[DAT_00102280]                               = 25h    %
                 5f 09 00 00
        00101921 48 89 c7        MOV        RDI=>DAT_00102280,RAX                            = 25h    %
        00101924 b8 00 00        MOV        EAX,0x0
                 00 00
        00101929 e8 52 f8        CALL       <EXTERNAL>::__isoc99_scanf                       undefined __isoc99_scanf()
                 ff ff
        0010192e 48 8d 05        LEA        RAX,[password]                                   = "pge2j"
                 db 26 00 00
        00101935 48 89 45 d8     MOV        qword ptr [RBP + local_30],RAX=>password         = "pge2j"
        00101939 48 8b 55 d8     MOV        RDX=>password,qword ptr [RBP + local_30]         = "pge2j"
        0010193d 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101941 48 89 d6        MOV        RSI=>password,RDX                                = "pge2j"
        00101944 48 89 c7        MOV        RDI,RAX
        00101947 e8 04 f8        CALL       <EXTERNAL>::strcmp                               int strcmp(char * __s1, char * _
                 ff ff
        0010194c 85 c0           TEST       EAX,EAX
        0010194e 75 0c           JNZ        LAB_0010195c
        00101950 bf 01 00        MOV        EDI,0x1
                 00 00
        00101955 e8 30 fb        CALL       seven                                            undefined seven()
                 ff ff
        0010195a eb 23           JMP        LAB_0010197f
                             LAB_0010195c                                    XREF[1]:     0010194e(j)  
        0010195c 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 c5 06 00 00
        00101963 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        00101966 e8 c5 f7        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        0010196b 48 8d 05        LEA        RAX,[s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
                 16 09 00 00
        00101972 48 89 c7        MOV        RDI=>s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
        00101975 e8 ff fb        CALL       type                                             undefined type()
                 ff ff
        0010197a b8 00 00        MOV        EAX,0x0
                 00 00
                             LAB_0010197f                                    XREF[1]:     0010195a(j)  
        0010197f 48 8b 55 f8     MOV        RDX,qword ptr [RBP + local_10]
        00101983 64 48 2b        SUB        RDX,qword ptr FS:[0x28]
                 14 25 28 
                 00 00 00
        0010198c 74 05           JZ         LAB_00101993
        0010198e e8 8d f7        CALL       <EXTERNAL>::__stack_chk_fail                     undefined __stack_chk_fail()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             LAB_00101993                                    XREF[1]:     0010198c(j)  
        00101993 c9              LEAVE
        00101994 c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined five()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     001019aa(W), 
                                                                                                   00101a3a(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[2]:     001019ce(*), 
                                                                                                   001019f8(*)  
             undefined8        Stack[-0x30]:8 local_30                                XREF[2]:     001019f0(W), 
                                                                                                   001019f4(R)  
                             five                                            XREF[4]:     Entry Point(*), loop:0010141a(c), 
                                                                                          001024f0, 001026d4(*)  
        00101995 f3 0f 1e fa     ENDBR64
        00101999 55              PUSH       RBP
        0010199a 48 89 e5        MOV        RBP,RSP
        0010199d 48 83 ec 30     SUB        RSP,0x30
        001019a1 64 48 8b        MOV        RAX,qword ptr FS:[0x28]
                 04 25 28 
                 00 00 00
        001019aa 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
        001019ae 31 c0           XOR        EAX,EAX
        001019b0 48 8b 05        MOV        RAX,qword ptr [stdin]
                 79 26 00 00
        001019b7 48 89 c7        MOV        RDI,RAX
        001019ba e8 a1 f7        CALL       <EXTERNAL>::fflush                               int fflush(FILE * __stream)
                 ff ff
        001019bf 48 8d 05        LEA        RAX,[s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
                 92 08 00 00
        001019c6 48 89 c7        MOV        RDI=>s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
        001019c9 e8 ab fb        CALL       type                                             undefined type()
                 ff ff
        001019ce 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        001019d2 48 89 c6        MOV        RSI,RAX
        001019d5 48 8d 05        LEA        RAX,[DAT_00102280]                               = 25h    %
                 a4 08 00 00
        001019dc 48 89 c7        MOV        RDI=>DAT_00102280,RAX                            = 25h    %
        001019df b8 00 00        MOV        EAX,0x0
                 00 00
        001019e4 e8 97 f7        CALL       <EXTERNAL>::__isoc99_scanf                       undefined __isoc99_scanf()
                 ff ff
        001019e9 48 8d 05        LEA        RAX,[password]                                   = "pge2j"
                 20 26 00 00
        001019f0 48 89 45 d8     MOV        qword ptr [RBP + local_30],RAX=>password         = "pge2j"
        001019f4 48 8b 55 d8     MOV        RDX=>password,qword ptr [RBP + local_30]         = "pge2j"
        001019f8 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        001019fc 48 89 d6        MOV        RSI=>password,RDX                                = "pge2j"
        001019ff 48 89 c7        MOV        RDI,RAX
        00101a02 e8 49 f7        CALL       <EXTERNAL>::strcmp                               int strcmp(char * __s1, char * _
                 ff ff
        00101a07 85 c0           TEST       EAX,EAX
        00101a09 75 0c           JNZ        LAB_00101a17
        00101a0b bf 01 00        MOV        EDI,0x1
                 00 00
        00101a10 e8 75 fa        CALL       seven                                            undefined seven()
                 ff ff
        00101a15 eb 23           JMP        LAB_00101a3a
                             LAB_00101a17                                    XREF[1]:     00101a09(j)  
        00101a17 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 0a 06 00 00
        00101a1e 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        00101a21 e8 0a f7        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        00101a26 48 8d 05        LEA        RAX,[s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
                 5b 08 00 00
        00101a2d 48 89 c7        MOV        RDI=>s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
        00101a30 e8 44 fb        CALL       type                                             undefined type()
                 ff ff
        00101a35 b8 00 00        MOV        EAX,0x0
                 00 00
                             LAB_00101a3a                                    XREF[1]:     00101a15(j)  
        00101a3a 48 8b 55 f8     MOV        RDX,qword ptr [RBP + local_10]
        00101a3e 64 48 2b        SUB        RDX,qword ptr FS:[0x28]
                 14 25 28 
                 00 00 00
        00101a47 74 05           JZ         LAB_00101a4e
        00101a49 e8 d2 f6        CALL       <EXTERNAL>::__stack_chk_fail                     undefined __stack_chk_fail()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             LAB_00101a4e                                    XREF[1]:     00101a47(j)  
        00101a4e c9              LEAVE
        00101a4f c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined six()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     00101a65(W), 
                                                                                                   00101af5(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[2]:     00101a89(*), 
                                                                                                   00101ab3(*)  
             undefined8        Stack[-0x30]:8 local_30                                XREF[2]:     00101aab(W), 
                                                                                                   00101aaf(R)  
                             six                                             XREF[4]:     Entry Point(*), loop:00101426(c), 
                                                                                          001024f8, 001026f4(*)  
        00101a50 f3 0f 1e fa     ENDBR64
        00101a54 55              PUSH       RBP
        00101a55 48 89 e5        MOV        RBP,RSP
        00101a58 48 83 ec 30     SUB        RSP,0x30
        00101a5c 64 48 8b        MOV        RAX,qword ptr FS:[0x28]
                 04 25 28 
                 00 00 00
        00101a65 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
        00101a69 31 c0           XOR        EAX,EAX
        00101a6b 48 8b 05        MOV        RAX,qword ptr [stdin]
                 be 25 00 00
        00101a72 48 89 c7        MOV        RDI,RAX
        00101a75 e8 e6 f6        CALL       <EXTERNAL>::fflush                               int fflush(FILE * __stream)
                 ff ff
        00101a7a 48 8d 05        LEA        RAX,[s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
                 d7 07 00 00
        00101a81 48 89 c7        MOV        RDI=>s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
        00101a84 e8 f0 fa        CALL       type                                             undefined type()
                 ff ff
        00101a89 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101a8d 48 89 c6        MOV        RSI,RAX
        00101a90 48 8d 05        LEA        RAX,[DAT_00102280]                               = 25h    %
                 e9 07 00 00
        00101a97 48 89 c7        MOV        RDI=>DAT_00102280,RAX                            = 25h    %
        00101a9a b8 00 00        MOV        EAX,0x0
                 00 00
        00101a9f e8 dc f6        CALL       <EXTERNAL>::__isoc99_scanf                       undefined __isoc99_scanf()
                 ff ff
        00101aa4 48 8d 05        LEA        RAX,[password]                                   = "pge2j"
                 65 25 00 00
        00101aab 48 89 45 d8     MOV        qword ptr [RBP + local_30],RAX=>password         = "pge2j"
        00101aaf 48 8b 55 d8     MOV        RDX=>password,qword ptr [RBP + local_30]         = "pge2j"
        00101ab3 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101ab7 48 89 d6        MOV        RSI=>password,RDX                                = "pge2j"
        00101aba 48 89 c7        MOV        RDI,RAX
        00101abd e8 8e f6        CALL       <EXTERNAL>::strcmp                               int strcmp(char * __s1, char * _
                 ff ff
        00101ac2 85 c0           TEST       EAX,EAX
        00101ac4 75 0c           JNZ        LAB_00101ad2
        00101ac6 bf 01 00        MOV        EDI,0x1
                 00 00
        00101acb e8 ba f9        CALL       seven                                            undefined seven()
                 ff ff
        00101ad0 eb 23           JMP        LAB_00101af5
                             LAB_00101ad2                                    XREF[1]:     00101ac4(j)  
        00101ad2 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 4f 05 00 00
        00101ad9 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        00101adc e8 4f f6        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        00101ae1 48 8d 05        LEA        RAX,[s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
                 a0 07 00 00
        00101ae8 48 89 c7        MOV        RDI=>s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
        00101aeb e8 89 fa        CALL       type                                             undefined type()
                 ff ff
        00101af0 b8 00 00        MOV        EAX,0x0
                 00 00
                             LAB_00101af5                                    XREF[1]:     00101ad0(j)  
        00101af5 48 8b 55 f8     MOV        RDX,qword ptr [RBP + local_10]
        00101af9 64 48 2b        SUB        RDX,qword ptr FS:[0x28]
                 14 25 28 
                 00 00 00
        00101b02 74 05           JZ         LAB_00101b09
        00101b04 e8 17 f6        CALL       <EXTERNAL>::__stack_chk_fail                     undefined __stack_chk_fail()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             LAB_00101b09                                    XREF[1]:     00101b02(j)  
        00101b09 c9              LEAVE
        00101b0a c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined eight()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     00101b20(W), 
                                                                                                   00101bb0(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[2]:     00101b44(*), 
                                                                                                   00101b6e(*)  
             undefined8        Stack[-0x30]:8 local_30                                XREF[2]:     00101b66(W), 
                                                                                                   00101b6a(R)  
                             eight                                           XREF[4]:     Entry Point(*), loop:00101432(c), 
                                                                                          00102500, 00102714(*)  
        00101b0b f3 0f 1e fa     ENDBR64
        00101b0f 55              PUSH       RBP
        00101b10 48 89 e5        MOV        RBP,RSP
        00101b13 48 83 ec 30     SUB        RSP,0x30
        00101b17 64 48 8b        MOV        RAX,qword ptr FS:[0x28]
                 04 25 28 
                 00 00 00
        00101b20 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
        00101b24 31 c0           XOR        EAX,EAX
        00101b26 48 8b 05        MOV        RAX,qword ptr [stdin]
                 03 25 00 00
        00101b2d 48 89 c7        MOV        RDI,RAX
        00101b30 e8 2b f6        CALL       <EXTERNAL>::fflush                               int fflush(FILE * __stream)
                 ff ff
        00101b35 48 8d 05        LEA        RAX,[s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
                 1c 07 00 00
        00101b3c 48 89 c7        MOV        RDI=>s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
        00101b3f e8 35 fa        CALL       type                                             undefined type()
                 ff ff
        00101b44 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101b48 48 89 c6        MOV        RSI,RAX
        00101b4b 48 8d 05        LEA        RAX,[DAT_00102280]                               = 25h    %
                 2e 07 00 00
        00101b52 48 89 c7        MOV        RDI=>DAT_00102280,RAX                            = 25h    %
        00101b55 b8 00 00        MOV        EAX,0x0
                 00 00
        00101b5a e8 21 f6        CALL       <EXTERNAL>::__isoc99_scanf                       undefined __isoc99_scanf()
                 ff ff
        00101b5f 48 8d 05        LEA        RAX,[password]                                   = "pge2j"
                 aa 24 00 00
        00101b66 48 89 45 d8     MOV        qword ptr [RBP + local_30],RAX=>password         = "pge2j"
        00101b6a 48 8b 55 d8     MOV        RDX=>password,qword ptr [RBP + local_30]         = "pge2j"
        00101b6e 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101b72 48 89 d6        MOV        RSI=>password,RDX                                = "pge2j"
        00101b75 48 89 c7        MOV        RDI,RAX
        00101b78 e8 d3 f5        CALL       <EXTERNAL>::strcmp                               int strcmp(char * __s1, char * _
                 ff ff
        00101b7d 85 c0           TEST       EAX,EAX
        00101b7f 75 0c           JNZ        LAB_00101b8d
        00101b81 bf 01 00        MOV        EDI,0x1
                 00 00
        00101b86 e8 ff f8        CALL       seven                                            undefined seven()
                 ff ff
        00101b8b eb 23           JMP        LAB_00101bb0
                             LAB_00101b8d                                    XREF[1]:     00101b7f(j)  
        00101b8d 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 94 04 00 00
        00101b94 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        00101b97 e8 94 f5        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        00101b9c 48 8d 05        LEA        RAX,[s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
                 e5 06 00 00
        00101ba3 48 89 c7        MOV        RDI=>s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
        00101ba6 e8 ce f9        CALL       type                                             undefined type()
                 ff ff
        00101bab b8 00 00        MOV        EAX,0x0
                 00 00
                             LAB_00101bb0                                    XREF[1]:     00101b8b(j)  
        00101bb0 48 8b 55 f8     MOV        RDX,qword ptr [RBP + local_10]
        00101bb4 64 48 2b        SUB        RDX,qword ptr FS:[0x28]
                 14 25 28 
                 00 00 00
        00101bbd 74 05           JZ         LAB_00101bc4
        00101bbf e8 5c f5        CALL       <EXTERNAL>::__stack_chk_fail                     undefined __stack_chk_fail()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             LAB_00101bc4                                    XREF[1]:     00101bbd(j)  
        00101bc4 c9              LEAVE
        00101bc5 c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined nine()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     00101bdb(W), 
                                                                                                   00101c6b(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[2]:     00101bff(*), 
                                                                                                   00101c29(*)  
             undefined8        Stack[-0x30]:8 local_30                                XREF[2]:     00101c21(W), 
                                                                                                   00101c25(R)  
                             nine                                            XREF[4]:     Entry Point(*), loop:0010143e(c), 
                                                                                          00102508, 00102734(*)  
        00101bc6 f3 0f 1e fa     ENDBR64
        00101bca 55              PUSH       RBP
        00101bcb 48 89 e5        MOV        RBP,RSP
        00101bce 48 83 ec 30     SUB        RSP,0x30
        00101bd2 64 48 8b        MOV        RAX,qword ptr FS:[0x28]
                 04 25 28 
                 00 00 00
        00101bdb 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
        00101bdf 31 c0           XOR        EAX,EAX
        00101be1 48 8b 05        MOV        RAX,qword ptr [stdin]
                 48 24 00 00
        00101be8 48 89 c7        MOV        RDI,RAX
        00101beb e8 70 f5        CALL       <EXTERNAL>::fflush                               int fflush(FILE * __stream)
                 ff ff
        00101bf0 48 8d 05        LEA        RAX,[s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
                 61 06 00 00
        00101bf7 48 89 c7        MOV        RDI=>s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
        00101bfa e8 7a f9        CALL       type                                             undefined type()
                 ff ff
        00101bff 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101c03 48 89 c6        MOV        RSI,RAX
        00101c06 48 8d 05        LEA        RAX,[DAT_00102280]                               = 25h    %
                 73 06 00 00
        00101c0d 48 89 c7        MOV        RDI=>DAT_00102280,RAX                            = 25h    %
        00101c10 b8 00 00        MOV        EAX,0x0
                 00 00
        00101c15 e8 66 f5        CALL       <EXTERNAL>::__isoc99_scanf                       undefined __isoc99_scanf()
                 ff ff
        00101c1a 48 8d 05        LEA        RAX,[password]                                   = "pge2j"
                 ef 23 00 00
        00101c21 48 89 45 d8     MOV        qword ptr [RBP + local_30],RAX=>password         = "pge2j"
        00101c25 48 8b 55 d8     MOV        RDX=>password,qword ptr [RBP + local_30]         = "pge2j"
        00101c29 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101c2d 48 89 d6        MOV        RSI=>password,RDX                                = "pge2j"
        00101c30 48 89 c7        MOV        RDI,RAX
        00101c33 e8 18 f5        CALL       <EXTERNAL>::strcmp                               int strcmp(char * __s1, char * _
                 ff ff
        00101c38 85 c0           TEST       EAX,EAX
        00101c3a 75 0c           JNZ        LAB_00101c48
        00101c3c bf 01 00        MOV        EDI,0x1
                 00 00
        00101c41 e8 44 f8        CALL       seven                                            undefined seven()
                 ff ff
        00101c46 eb 23           JMP        LAB_00101c6b
                             LAB_00101c48                                    XREF[1]:     00101c3a(j)  
        00101c48 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 d9 03 00 00
        00101c4f 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        00101c52 e8 d9 f4        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        00101c57 48 8d 05        LEA        RAX,[s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
                 2a 06 00 00
        00101c5e 48 89 c7        MOV        RDI=>s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
        00101c61 e8 13 f9        CALL       type                                             undefined type()
                 ff ff
        00101c66 b8 00 00        MOV        EAX,0x0
                 00 00
                             LAB_00101c6b                                    XREF[1]:     00101c46(j)  
        00101c6b 48 8b 55 f8     MOV        RDX,qword ptr [RBP + local_10]
        00101c6f 64 48 2b        SUB        RDX,qword ptr FS:[0x28]
                 14 25 28 
                 00 00 00
        00101c78 74 05           JZ         LAB_00101c7f
        00101c7a e8 a1 f4        CALL       <EXTERNAL>::__stack_chk_fail                     undefined __stack_chk_fail()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             LAB_00101c7f                                    XREF[1]:     00101c78(j)  
        00101c7f c9              LEAVE
        00101c80 c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined ten()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     00101c96(W), 
                                                                                                   00101d26(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[2]:     00101cba(*), 
                                                                                                   00101ce4(*)  
             undefined8        Stack[-0x30]:8 local_30                                XREF[2]:     00101cdc(W), 
                                                                                                   00101ce0(R)  
                             ten                                             XREF[4]:     Entry Point(*), loop:0010144a(c), 
                                                                                          00102510, 00102754(*)  
        00101c81 f3 0f 1e fa     ENDBR64
        00101c85 55              PUSH       RBP
        00101c86 48 89 e5        MOV        RBP,RSP
        00101c89 48 83 ec 30     SUB        RSP,0x30
        00101c8d 64 48 8b        MOV        RAX,qword ptr FS:[0x28]
                 04 25 28 
                 00 00 00
        00101c96 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
        00101c9a 31 c0           XOR        EAX,EAX
        00101c9c 48 8b 05        MOV        RAX,qword ptr [stdin]
                 8d 23 00 00
        00101ca3 48 89 c7        MOV        RDI,RAX
        00101ca6 e8 b5 f4        CALL       <EXTERNAL>::fflush                               int fflush(FILE * __stream)
                 ff ff
        00101cab 48 8d 05        LEA        RAX,[s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
                 a6 05 00 00
        00101cb2 48 89 c7        MOV        RDI=>s_What_is_the_passcode_to_the_comp_001022   = "What is the passcode to the c
        00101cb5 e8 bf f8        CALL       type                                             undefined type()
                 ff ff
        00101cba 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101cbe 48 89 c6        MOV        RSI,RAX
        00101cc1 48 8d 05        LEA        RAX,[DAT_00102280]                               = 25h    %
                 b8 05 00 00
        00101cc8 48 89 c7        MOV        RDI=>DAT_00102280,RAX                            = 25h    %
        00101ccb b8 00 00        MOV        EAX,0x0
                 00 00
        00101cd0 e8 ab f4        CALL       <EXTERNAL>::__isoc99_scanf                       undefined __isoc99_scanf()
                 ff ff
        00101cd5 48 8d 05        LEA        RAX,[password]                                   = "pge2j"
                 34 23 00 00
        00101cdc 48 89 45 d8     MOV        qword ptr [RBP + local_30],RAX=>password         = "pge2j"
        00101ce0 48 8b 55 d8     MOV        RDX=>password,qword ptr [RBP + local_30]         = "pge2j"
        00101ce4 48 8d 45 e0     LEA        RAX=>local_28,[RBP + -0x20]
        00101ce8 48 89 d6        MOV        RSI=>password,RDX                                = "pge2j"
        00101ceb 48 89 c7        MOV        RDI,RAX
        00101cee e8 5d f4        CALL       <EXTERNAL>::strcmp                               int strcmp(char * __s1, char * _
                 ff ff
        00101cf3 85 c0           TEST       EAX,EAX
        00101cf5 75 0c           JNZ        LAB_00101d03
        00101cf7 bf 01 00        MOV        EDI,0x1
                 00 00
        00101cfc e8 89 f7        CALL       seven                                            undefined seven()
                 ff ff
        00101d01 eb 23           JMP        LAB_00101d26
                             LAB_00101d03                                    XREF[1]:     00101cf5(j)  
        00101d03 48 8d 05        LEA        RAX,[s_clear_00102028]                           = "clear"
                 1e 03 00 00
        00101d0a 48 89 c7        MOV        RDI=>s_clear_00102028,RAX                        = "clear"
        00101d0d e8 1e f4        CALL       <EXTERNAL>::system                               int system(char * __command)
                 ff ff
        00101d12 48 8d 05        LEA        RAX,[s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
                 6f 05 00 00
        00101d19 48 89 c7        MOV        RDI=>s_There_seems_to_have_been_a_mix_u_001022   = "There seems to have been a mi
        00101d1c e8 58 f8        CALL       type                                             undefined type()
                 ff ff
        00101d21 b8 00 00        MOV        EAX,0x0
                 00 00
                             LAB_00101d26                                    XREF[1]:     00101d01(j)  
        00101d26 48 8b 55 f8     MOV        RDX,qword ptr [RBP + local_10]
        00101d2a 64 48 2b        SUB        RDX,qword ptr FS:[0x28]
                 14 25 28 
                 00 00 00
        00101d33 74 05           JZ         LAB_00101d3a
        00101d35 e8 e6 f3        CALL       <EXTERNAL>::__stack_chk_fail                     undefined __stack_chk_fail()
                 ff ff
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
                             LAB_00101d3a                                    XREF[1]:     00101d33(j)  
        00101d3a c9              LEAVE
        00101d3b c3              RET
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined eleven()
             undefined         AL:1           <RETURN>
                             eleven                                          XREF[4]:     Entry Point(*), loop:00101305(c), 
                                                                                          00102518, 00102774(*)  
        00101d3c f3 0f 1e fa     ENDBR64
        00101d40 55              PUSH       RBP
        00101d41 48 89 e5        MOV        RBP,RSP
        00101d44 48 8d 05        LEA        RAX,[s_Where_is_the_AI's_access_code_hi_001023   = "Where is the AI's access code
                 c5 05 00 00
        00101d4b 48 89 c7        MOV        RDI=>s_Where_is_the_AI's_access_code_hi_001023   = "Where is the AI's access code
        00101d4e e8 26 f8        CALL       type                                             undefined type()
                 ff ff
        00101d53 48 8d 05        LEA        RAX,[s_-_In_the_remains_of_the_Python_P_001023   = " - In the remains of the Pyth
                 de 05 00 00
        00101d5a 48 89 c7        MOV        RDI=>s_-_In_the_remains_of_the_Python_P_001023   = " - In the remains of the Pyth
        00101d5d e8 17 f8        CALL       type                                             undefined type()
                 ff ff
        00101d62 48 8d 05        LEA        RAX,[s_-_In_the_jaws_of_the_sharks_in_t_001023   = " - In the jaws of the sharks 
                 f7 05 00 00
        00101d69 48 89 c7        MOV        RDI=>s_-_In_the_jaws_of_the_sharks_in_t_001023   = " - In the jaws of the sharks 
        00101d6c e8 08 f8        CALL       type                                             undefined type()
                 ff ff
        00101d71 48 8d 05        LEA        RAX,[s_-_In_the_chaos_of_the_carnival?_00102390] = " - In the chaos of the carniv
                 18 06 00 00
        00101d78 48 89 c7        MOV        RDI=>s_-_In_the_chaos_of_the_carnival?_0010239   = " - In the chaos of the carniv
        00101d7b e8 f9 f7        CALL       type                                             undefined type()
                 ff ff
        00101d80 48 8d 05        LEA        RAX,[s_-_Under_the_Rusty_Rollercoaster?_001023   = " - Under the Rusty Rollercoas
                 31 06 00 00
        00101d87 48 89 c7        MOV        RDI=>s_-_Under_the_Rusty_Rollercoaster?_001023   = " - Under the Rusty Rollercoas
        00101d8a e8 ea f7        CALL       type                                             undefined type()
                 ff ff
        00101d8f 48 8d 05        LEA        RAX,[s_-_Somewhere_in_Mirror_Mayhem?_001023e0]   = " - Somewhere in Mirror Mayhem
                 4a 06 00 00
        00101d96 48 89 c7        MOV        RDI=>s_-_Somewhere_in_Mirror_Mayhem?_001023e0,   = " - Somewhere in Mirror Mayhem
        00101d99 e8 db f7        CALL       type                                             undefined type()
                 ff ff
        00101d9e 48 8d 05        LEA        RAX,[s_-_In_the_Cursed_Crypt?_00102400]          = " - In the Cursed Crypt?\n"
                 5b 06 00 00
        00101da5 48 89 c7        MOV        RDI=>s_-_In_the_Cursed_Crypt?_00102400,RAX       = " - In the Cursed Crypt?\n"
        00101da8 e8 cc f7        CALL       type                                             undefined type()
                 ff ff
        00101dad 48 8d 05        LEA        RAX,[s_Which_route_do_you_want_to_take?_001024   = "Which route do you want to ta
                 6c 06 00 00
        00101db4 48 89 c7        MOV        RDI=>s_Which_route_do_you_want_to_take?_001024   = "Which route do you want to ta
        00101db7 e8 bd f7        CALL       type                                             undefined type()
                 ff ff
        00101dbc 90              NOP
        00101dbd 5d              POP        RBP
        00101dbe c3              RET
                             //
                             // .fini 
                             // SHT_PROGBITS  [0x1dc0 - 0x1dcc]
                             // ram:00101dc0-ram:00101dcc
                             //
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined _fini()
             undefined         AL:1           <RETURN>
                             __DT_FINI                                       XREF[3]:     Entry Point(*), 00103da0(*), 
                             _fini                                                        _elfSectionHeaders::00000450(*)  
        00101dc0 f3 0f 1e fa     ENDBR64
        00101dc4 48 83 ec 08     SUB        RSP,0x8
        00101dc8 48 83 c4 08     ADD        RSP,0x8
        00101dcc c3              RET
                             //
                             // .rodata 
                             // SHT_PROGBITS  [0x2000 - 0x247b]
                             // ram:00102000-ram:0010247b
                             //
                             _IO_stdin_used                                  XREF[3]:     Entry Point(*), 00100130(*), 
                                                                                          _elfSectionHeaders::00000490(*)  
        00102000 01 00 02 00     undefined4 00020001h
        00102004 00              ??         00h
        00102005 00              ??         00h
        00102006 00              ??         00h
        00102007 00              ??         00h
                             s_Welcome_doomed_investigator_00102008          XREF[2]:     main:00101295(*), 
                                                                                          main:0010129c(*)  
        00102008 57 65 6c        ds         "Welcome doomed investigator\n"
                 63 6f 6d 
                 65 20 64 
                             DAT_00102025                                    XREF[2]:     loop:00101311(*), 
                                                                                          loop:00101318(*)  
        00102025 25              ??         25h    %
        00102026 64              ??         64h    d
        00102027 00              ??         00h
                             s_clear_00102028                                XREF[26]:    loop:00101451(*), 
                                                                                          loop:00101458(*), 
                                                                                          seven:0010150f(*), 
                                                                                          seven:00101516(*), 
                                                                                          seven:00101540(*), 
                                                                                          seven:00101547(*), 
                                                                                          one:0010172b(*), one:00101732(*), 
                                                                                          three:001018a1(*), 
                                                                                          three:001018a8(*), 
                                                                                          four:0010195c(*), 
                                                                                          four:00101963(*), 
                                                                                          five:00101a17(*), 
                                                                                          five:00101a1e(*), 
                                                                                          six:00101ad2(*), 
                                                                                          eight:00101b8d(*), 
                                                                                          eight:00101b94(*), 
                                                                                          nine:00101c48(*), 
                                                                                          nine:00101c4f(*), 
                                                                                          ten:00101d03(*), [more]
        00102028 63 6c 65        ds         "clear"
                 61 72 00
        0010202e 00              ??         00h
        0010202f 00              ??         00h
                             s_There_seems_to_have_been_a_mix_u_00102030     XREF[2]:     loop:00101460(*), 
                                                                                          loop:00101467(*)  
        00102030 54 68 65        ds         "There seems to have been a mix up, you can't 
                 72 65 20 
                 73 65 65 
                             DAT_001020ab                                    XREF[2]:     seven:001014b9(*), 
                                                                                          seven:001014c0(*)  
        001020ab 72              ??         72h    r
        001020ac 00              ??         00h
                             s_/root/token.txt_001020ad                      XREF[2]:     seven:001014c3(*), 
                                                                                          seven:001014ca(*)  
        001020ad 2f 72 6f        ds         "/root/token.txt"
                 6f 74 2f 
                 74 6f 6b 
        001020bd 00              ??         00h
        001020be 00              ??         00h
        001020bf 00              ??         00h
                             s_You_go_to_the_correct_ride_and_u_001020c0     XREF[2]:     seven:001014dd(*), 
                                                                                          seven:001014e4(*)  
        001020c0 59 6f 75        ds         "You go to the correct ride and unlock the com
                 20 67 6f 
                 20 74 6f 
        00102142 00              ??         00h
        00102143 00              ??         00h
        00102144 00              ??         00h
        00102145 00              ??         00h
        00102146 00              ??         00h
        00102147 00              ??         00h
                             s_Error_opening_file_-_do_you_have_00102148     XREF[2]:     seven:0010151e(*), 
                                                                                          seven:00101525(*)  
        00102148 45 72 72        ds         "Error opening file - do you have permission t
                 6f 72 20 
                 6f 70 65 
        0010219f 00              ??         00h
                             s_There_seems_to_have_been_a_mix_u_001021a0     XREF[2]:     seven:0010154f(*), 
                                                                                          seven:00101556(*)  
        001021a0 54 68 65        ds         "There seems to have been a mix up, you can't 
                 72 65 20 
                 73 65 65 
        00102251 00              ??         00h
        00102252 00              ??         00h
        00102253 00              ??         00h
        00102254 00              ??         00h
        00102255 00              ??         00h
        00102256 00              ??         00h
        00102257 00              ??         00h
                             s_What_is_the_passcode_to_the_comp_00102258     XREF[20]:    zero:00101618(*), 
                                                                                          zero:0010161f(*), 
                                                                                          one:001016d3(*), one:001016da(*), 
                                                                                          two:0010178e(*), two:00101795(*), 
                                                                                          three:00101849(*), 
                                                                                          three:00101850(*), 
                                                                                          four:00101904(*), 
                                                                                          four:0010190b(*), 
                                                                                          five:001019bf(*), 
                                                                                          five:001019c6(*), 
                                                                                          six:00101a7a(*), six:00101a81(*), 
                                                                                          eight:00101b35(*), 
                                                                                          eight:00101b3c(*), 
                                                                                          nine:00101bf0(*), 
                                                                                          nine:00101bf7(*), 
                                                                                          ten:00101cab(*), ten:00101cb2(*)  
        00102258 57 68 61        ds         "What is the passcode to the computer?: "
                 74 20 69 
                 73 20 74 
                             DAT_00102280                                    XREF[20]:    zero:0010162e(*), 
                                                                                          zero:00101635(*), 
                                                                                          one:001016e9(*), one:001016f0(*), 
                                                                                          two:001017a4(*), two:001017ab(*), 
                                                                                          three:0010185f(*), 
                                                                                          three:00101866(*), 
                                                                                          four:0010191a(*), 
                                                                                          four:00101921(*), 
                                                                                          five:001019d5(*), 
                                                                                          five:001019dc(*), 
                                                                                          six:00101a90(*), six:00101a97(*), 
                                                                                          eight:00101b4b(*), 
                                                                                          eight:00101b52(*), 
                                                                                          nine:00101c06(*), 
                                                                                          nine:00101c0d(*), 
                                                                                          ten:00101cc1(*), ten:00101cc8(*)  
        00102280 25              ??         25h    %
        00102281 31              ??         31h    1
        00102282 39              ??         39h    9
        00102283 73              ??         73h    s
        00102284 00              ??         00h
        00102285 00              ??         00h
        00102286 00              ??         00h
        00102287 00              ??         00h
                             s_There_seems_to_have_been_a_mix_u_00102288     XREF[20]:    zero:0010167f(*), 
                                                                                          zero:00101686(*), 
                                                                                          one:0010173a(*), one:00101741(*), 
                                                                                          two:001017f5(*), two:001017fc(*), 
                                                                                          three:001018b0(*), 
                                                                                          three:001018b7(*), 
                                                                                          four:0010196b(*), 
                                                                                          four:00101972(*), 
                                                                                          five:00101a26(*), 
                                                                                          five:00101a2d(*), 
                                                                                          six:00101ae1(*), six:00101ae8(*), 
                                                                                          eight:00101b9c(*), 
                                                                                          eight:00101ba3(*), 
                                                                                          nine:00101c57(*), 
                                                                                          nine:00101c5e(*), 
                                                                                          ten:00101d12(*), ten:00101d19(*)  
        00102288 54 68 65        ds         "There seems to have been a mix up, you've ent
                 72 65 20 
                 73 65 65 
        0010230e 00              ??         00h
        0010230f 00              ??         00h
                             s_Where_is_the_AI's_access_code_hi_00102310     XREF[2]:     eleven:00101d44(*), 
                                                                                          eleven:00101d4b(*)  
        00102310 57 68 65        ds         "Where is the AI's access code hidden?\n"
                 72 65 20 
                 69 73 20 
        00102337 00              ??         00h
                             s_-_In_the_remains_of_the_Python_P_00102338     XREF[2]:     eleven:00101d53(*), 
                                                                                          eleven:00101d5a(*)  
        00102338 20 2d 20        ds         " - In the remains of the Python Pit?\n"
                 49 6e 20 
                 74 68 65 
        0010235e 00              ??         00h
        0010235f 00              ??         00h
                             s_-_In_the_jaws_of_the_sharks_in_t_00102360     XREF[2]:     eleven:00101d62(*), 
                                                                                          eleven:00101d69(*)  
        00102360 20 2d 20        ds         " - In the jaws of the sharks in their pool?\n"
                 49 6e 20 
                 74 68 65 
        0010238d 00              ??         00h
        0010238e 00              ??         00h
        0010238f 00              ??         00h
                             s_-_In_the_chaos_of_the_carnival?_00102390      XREF[2]:     eleven:00101d71(*), 
                                                                                          eleven:00101d78(*)  
        00102390 20 2d 20        ds         " - In the chaos of the carnival?\n"
                 49 6e 20 
                 74 68 65 
        001023b2 00              ??         00h
        001023b3 00              ??         00h
        001023b4 00              ??         00h
        001023b5 00              ??         00h
        001023b6 00              ??         00h
        001023b7 00              ??         00h
                             s_-_Under_the_Rusty_Rollercoaster?_001023b8     XREF[2]:     eleven:00101d80(*), 
                                                                                          eleven:00101d87(*)  
        001023b8 20 2d 20        ds         " - Under the Rusty Rollercoaster?\n"
                 55 6e 64 
                 65 72 20 
        001023db 00              ??         00h
        001023dc 00              ??         00h
        001023dd 00              ??         00h
        001023de 00              ??         00h
        001023df 00              ??         00h
                             s_-_Somewhere_in_Mirror_Mayhem?_001023e0        XREF[2]:     eleven:00101d8f(*), 
                                                                                          eleven:00101d96(*)  
        001023e0 20 2d 20        ds         " - Somewhere in Mirror Mayhem?\n"
                 53 6f 6d 
                 65 77 68 
                             s_-_In_the_Cursed_Crypt?_00102400               XREF[2]:     eleven:00101d9e(*), 
                                                                                          eleven:00101da5(*)  
        00102400 20 2d 20        ds         " - In the Cursed Crypt?\n"
                 49 6e 20 
                 74 68 65 
        00102419 00              ??         00h
        0010241a 00              ??         00h
        0010241b 00              ??         00h
        0010241c 00              ??         00h
        0010241d 00              ??         00h
        0010241e 00              ??         00h
        0010241f 00              ??         00h
                             s_Which_route_do_you_want_to_take?_00102420     XREF[2]:     eleven:00101dad(*), 
                                                                                          eleven:00101db4(*)  
        00102420 57 68 69        ds         "Which route do you want to take? - enter the 
                 63 68 20 
                 72 6f 75 
                             //
                             // .eh_frame_hdr 
                             // SHT_PROGBITS  [0x247c - 0x251f]
                             // ram:0010247c-ram:0010251f
                             //
                             **************************************************************
                             * Exception Handler Frame Header                             *
                             **************************************************************
                             __GNU_EH_FRAME_HDR                              XREF[2]:     00100280(*), 
                                                                                          _elfSectionHeaders::000004d0(*)  
        0010247c 01 1b 03 3b     eh_frame                                                    Exception Handler Frame Header V
        00102480 a0 00 00 00     ddw        cie_00102520                                     Encoded eh_frame_ptr
        00102484 13 00 00 00     ddw        13h                                              Encoded FDE count
                             **************************************************************
                             * Frame Description Entry Table                              *
                             **************************************************************
        00102488 a4 eb ff        fde_tabl                                                    Initial Location
                 ff d4 00 
                 00 00
        00102490 64 ec ff        fde_tabl                                                    Initial Location
                 ff fc 00 
                 00 00
        00102498 74 ec ff        fde_tabl                                                    Initial Location
                 ff 14 01 
                 00 00
        001024a0 24 ed ff        fde_tabl                                                    Initial Location
                 ff bc 00 
                 00 00
        001024a8 0d ee ff        fde_tabl                                                    Initial Location
                 ff 2c 01 
                 00 00
        001024b0 53 ee ff        fde_tabl                                                    Initial Location
                 ff 4c 01 
                 00 00
        001024b8 0e f0 ff        fde_tabl                                                    Initial Location
                 ff 6c 01 
                 00 00
        001024c0 fd f0 ff        fde_tabl                                                    Initial Location
                 ff 8c 01 
                 00 00
        001024c8 72 f1 ff        fde_tabl                                                    Initial Location
                 ff b0 01 
                 00 00
        001024d0 2d f2 ff        fde_tabl                                                    Initial Location
                 ff d0 01 
                 00 00
        001024d8 e8 f2 ff        fde_tabl                                                    Initial Location
                 ff f0 01 
                 00 00
        001024e0 a3 f3 ff        fde_tabl                                                    Initial Location
                 ff 10 02 
                 00 00
        001024e8 5e f4 ff        fde_tabl                                                    Initial Location
                 ff 30 02 
                 00 00
        001024f0 19 f5 ff        fde_tabl                                                    Initial Location
                 ff 50 02 
                 00 00
        001024f8 d4 f5 ff        fde_tabl                                                    Initial Location
                 ff 70 02 
                 00 00
        00102500 8f f6 ff        fde_tabl                                                    Initial Location
                 ff 90 02 
                 00 00
        00102508 4a f7 ff        fde_tabl                                                    Initial Location
                 ff b0 02 
                 00 00
        00102510 05 f8 ff        fde_tabl                                                    Initial Location
                 ff d0 02 
                 00 00
        00102518 c0 f8 ff        fde_tabl                                                    Initial Location
                 ff f0 02 
                 00 00
                             //
                             // .eh_frame 
                             // SHT_PROGBITS  [0x2520 - 0x278f]
                             // ram:00102520-ram:0010278f
                             //
                             **************************************************************
                             * Common Information Entry                                   *
                             **************************************************************
                             cie_00102520                                    XREF[21]:    00102480(*), 0010253c(*), 
                                                                                          00102554(*), 0010257c(*), 
                                                                                          00102594(*), 001025ac(*), 
                                                                                          001025cc(*), 001025ec(*), 
                                                                                          0010260c(*), 00102630(*), 
                                                                                          00102650(*), 00102670(*), 
                                                                                          00102690(*), 001026b0(*), 
                                                                                          001026d0(*), 001026f0(*), 
                                                                                          00102710(*), 00102730(*), 
                                                                                          00102750(*), 00102770(*), [more]
        00102520 14 00 00 00     ddw        14h                                              (CIE) Length
        00102524 00 00 00 00     ddw        0h                                               (CIE) ID
        00102528 01              db         1h                                               (CIE) Version
        00102529 7a 52 00        ds         "zR"                                             (CIE) Augmentation String
        0010252c 01              uleb128    1h                                               (CIE) Code Alignment
        0010252d 78              sleb128    -8h                                              (CIE) Data Alignment
        0010252e 10              db         10h                                              (CIE) Return Address Register Co
        0010252f 01              uleb128    1h                                               (CIE) Augmentation Data Length
        00102530 1b              dwfenc     DW_EH_PE_sdata4 | DW_EH_PE_pcrel                 (CIE Augmentation Data) FDE Enco
        00102531 0c 07 08        db[7]                                                       (CIE) Initial Instructions
                 90 01 00 00
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_00102538                                    XREF[1]:     001024a4(*)  
        00102538 14 00 00 00     ddw        14h                                              (FDE) Length
        0010253c 1c 00 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102540 60 ec ff ff     ddw        _start                                           (FDE) PcBegin
        00102544 26 00 00 00     ddw        26h                                              (FDE) PcRange
        00102548 00              uleb128    0h                                               (FDE) Augmentation Data Length
        00102549 44 07 10        db[7]                                                       (FDE) Call Frame Instructions
                 00 00 00 00
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_00102550                                    XREF[1]:     0010248c(*)  
        00102550 24 00 00 00     ddw        24h                                              (FDE) Length
        00102554 34 00 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102558 c8 ea ff ff     ddw        FUN_00101020                                     (FDE) PcBegin
        0010255c c0 00 00 00     ddw        C0h                                              (FDE) PcRange
        00102560 00              uleb128    0h                                               (FDE) Augmentation Data Length
        00102561 0e 10 46        db[23]                                                      (FDE) Call Frame Instructions
                 0e 18 4a 
                 0f 0b 77 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_00102578                                    XREF[1]:     00102494(*)  
        00102578 14 00 00 00     ddw        14h                                              (FDE) Length
        0010257c 5c 00 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102580 60 eb ff ff     ddw        FUN_001010e0                                     (FDE) PcBegin
        00102584 10 00 00        dq         10h                                              (FDE) PcRange
                 00 00 00 
                 00 00
        0010258c 00              uleb128    0h                                               (FDE) Augmentation Data Length
        0010258d 00 00 00        db[3]                                                       (FDE) Call Frame Instructions
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_00102590                                    XREF[1]:     0010249c(*)  
        00102590 14 00 00 00     ddw        14h                                              (FDE) Length
        00102594 74 00 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102598 58 eb ff ff     ddw        <EXTERNAL>::putchar                              (FDE) PcBegin
        0010259c b0 00 00        dq         B0h                                              (FDE) PcRange
                 00 00 00 
                 00 00
        001025a4 00              uleb128    0h                                               (FDE) Augmentation Data Length
        001025a5 00 00 00        db[3]                                                       (FDE) Call Frame Instructions
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_001025a8                                    XREF[1]:     001024ac(*)  
        001025a8 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        001025ac 8c 00 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        001025b0 d9 ec ff ff     ddw        main                                             (FDE) PcBegin
        001025b4 46 00 00 00     ddw        46h                                              (FDE) PcRange
        001025b8 00              uleb128    0h                                               (FDE) Augmentation Data Length
        001025b9 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 7d 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_001025c8                                    XREF[1]:     001024b4(*)  
        001025c8 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        001025cc ac 00 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        001025d0 ff ec ff ff     ddw        loop                                             (FDE) PcBegin
        001025d4 bb 01 00 00     ddw        1BBh                                             (FDE) PcRange
        001025d8 00              uleb128    0h                                               (FDE) Augmentation Data Length
        001025d9 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 03 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_001025e8                                    XREF[1]:     001024bc(*)  
        001025e8 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        001025ec cc 00 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        001025f0 9a ee ff ff     ddw        seven                                            (FDE) PcBegin
        001025f4 ef 00 00 00     ddw        EFh                                              (FDE) PcRange
        001025f8 00              uleb128    0h                                               (FDE) Augmentation Data Length
        001025f9 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 02 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_00102608                                    XREF[1]:     001024c4(*)  
        00102608 20 00 00 00     ddw        20h                                              (FDE) Length
        0010260c ec 00 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102610 69 ef ff ff     ddw        type                                             (FDE) PcBegin
        00102614 75 00 00 00     ddw        75h                                              (FDE) PcRange
        00102618 00              uleb128    0h                                               (FDE) Augmentation Data Length
        00102619 45 0e 10        db[19]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 45 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_0010262c                                    XREF[1]:     001024cc(*)  
        0010262c 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        00102630 10 01 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102634 ba ef ff ff     ddw        zero                                             (FDE) PcBegin
        00102638 bb 00 00 00     ddw        BBh                                              (FDE) PcRange
        0010263c 00              uleb128    0h                                               (FDE) Augmentation Data Length
        0010263d 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 02 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_0010264c                                    XREF[1]:     001024d4(*)  
        0010264c 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        00102650 30 01 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102654 55 f0 ff ff     ddw        one                                              (FDE) PcBegin
        00102658 bb 00 00 00     ddw        BBh                                              (FDE) PcRange
        0010265c 00              uleb128    0h                                               (FDE) Augmentation Data Length
        0010265d 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 02 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_0010266c                                    XREF[1]:     001024dc(*)  
        0010266c 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        00102670 50 01 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102674 f0 f0 ff ff     ddw        two                                              (FDE) PcBegin
        00102678 bb 00 00 00     ddw        BBh                                              (FDE) PcRange
        0010267c 00              uleb128    0h                                               (FDE) Augmentation Data Length
        0010267d 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 02 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_0010268c                                    XREF[1]:     001024e4(*)  
        0010268c 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        00102690 70 01 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102694 8b f1 ff ff     ddw        three                                            (FDE) PcBegin
        00102698 bb 00 00 00     ddw        BBh                                              (FDE) PcRange
        0010269c 00              uleb128    0h                                               (FDE) Augmentation Data Length
        0010269d 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 02 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_001026ac                                    XREF[1]:     001024ec(*)  
        001026ac 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        001026b0 90 01 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        001026b4 26 f2 ff ff     ddw        four                                             (FDE) PcBegin
        001026b8 bb 00 00 00     ddw        BBh                                              (FDE) PcRange
        001026bc 00              uleb128    0h                                               (FDE) Augmentation Data Length
        001026bd 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 02 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_001026cc                                    XREF[1]:     001024f4(*)  
        001026cc 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        001026d0 b0 01 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        001026d4 c1 f2 ff ff     ddw        five                                             (FDE) PcBegin
        001026d8 bb 00 00 00     ddw        BBh                                              (FDE) PcRange
        001026dc 00              uleb128    0h                                               (FDE) Augmentation Data Length
        001026dd 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 02 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_001026ec                                    XREF[1]:     001024fc(*)  
        001026ec 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        001026f0 d0 01 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        001026f4 5c f3 ff ff     ddw        six                                              (FDE) PcBegin
        001026f8 bb 00 00 00     ddw        BBh                                              (FDE) PcRange
        001026fc 00              uleb128    0h                                               (FDE) Augmentation Data Length
        001026fd 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 02 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_0010270c                                    XREF[1]:     00102504(*)  
        0010270c 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        00102710 f0 01 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102714 f7 f3 ff ff     ddw        eight                                            (FDE) PcBegin
        00102718 bb 00 00 00     ddw        BBh                                              (FDE) PcRange
        0010271c 00              uleb128    0h                                               (FDE) Augmentation Data Length
        0010271d 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 02 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_0010272c                                    XREF[1]:     0010250c(*)  
        0010272c 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        00102730 10 02 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102734 92 f4 ff ff     ddw        nine                                             (FDE) PcBegin
        00102738 bb 00 00 00     ddw        BBh                                              (FDE) PcRange
        0010273c 00              uleb128    0h                                               (FDE) Augmentation Data Length
        0010273d 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 02 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_0010274c                                    XREF[1]:     00102514(*)  
        0010274c 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        00102750 30 02 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102754 2d f5 ff ff     ddw        ten                                              (FDE) PcBegin
        00102758 bb 00 00 00     ddw        BBh                                              (FDE) PcRange
        0010275c 00              uleb128    0h                                               (FDE) Augmentation Data Length
        0010275d 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 02 
                             **************************************************************
                             * Frame Descriptor Entry                                     *
                             **************************************************************
                             fde_0010276c                                    XREF[1]:     0010251c(*)  
        0010276c 1c 00 00 00     ddw        1Ch                                              (FDE) Length
        00102770 50 02 00 00     ddw        cie_00102520                                     (FDE) CIE Reference Pointer 
        00102774 c8 f5 ff ff     ddw        eleven                                           (FDE) PcBegin
        00102778 83 00 00 00     ddw        83h                                              (FDE) PcRange
        0010277c 00              uleb128    0h                                               (FDE) Augmentation Data Length
        0010277d 45 0e 10        db[15]                                                      (FDE) Call Frame Instructions
                 86 02 43 
                 0d 06 02 
                             **************************************************************
                             * END OF FRAME                                               *
                             **************************************************************
                             __FRAME_END__
        0010278c 00 00 00 00     ddw        0h                                               End of Frame
                             //
                             // .init_array 
                             // SHT_INIT_ARRAY  [0x3d68 - 0x3d6f]
                             // ram:00103d68-ram:00103d6f
                             //
                             __DT_INIT_ARRAY                                 XREF[4]:     00100168(*), 001002f0(*), 
                             __frame_dummy_init_array_entry                               00103db0(*), 
                                                                                          _elfSectionHeaders::00000550(*)  
        00103d68 80 12 10        addr       frame_dummy
                 00 00 00 
                 00 00
                             //
                             // .fini_array 
                             // SHT_FINI_ARRAY  [0x3d70 - 0x3d77]
                             // ram:00103d70-ram:00103d77
                             //
                             __DT_FINI_ARRAY                                 XREF[2]:     00103dd0(*), 
                             __do_global_dtors_aux_fini_array_entry                       _elfSectionHeaders::00000590(*)  
        00103d70 40 12 10        addr       __do_global_dtors_aux
                 00 00 00 
                 00 00
                             //
                             // .dynamic 
                             // SHT_DYNAMIC  [0x3d78 - 0x3f67]
                             // ram:00103d78-ram:00103f67
                             //
                             _DYNAMIC                                        XREF[3]:     001001a0(*), 00103f68(*), 
                                                                                          _elfSectionHeaders::000005d0(*)  
        00103d78 01 00 00        Elf64_Dy                                                    DT_NEEDED - Name of needed library
                 00 00 00 
                 00 00 8d 
        00103f28 00              ??         00h
        00103f29 00              ??         00h
        00103f2a 00              ??         00h
        00103f2b 00              ??         00h
        00103f2c 00              ??         00h
        00103f2d 00              ??         00h
        00103f2e 00              ??         00h
        00103f2f 00              ??         00h
        00103f30 00              ??         00h
        00103f31 00              ??         00h
        00103f32 00              ??         00h
        00103f33 00              ??         00h
        00103f34 00              ??         00h
        00103f35 00              ??         00h
        00103f36 00              ??         00h
        00103f37 00              ??         00h
        00103f38 00              ??         00h
        00103f39 00              ??         00h
        00103f3a 00              ??         00h
        00103f3b 00              ??         00h
        00103f3c 00              ??         00h
        00103f3d 00              ??         00h
        00103f3e 00              ??         00h
        00103f3f 00              ??         00h
        00103f40 00              ??         00h
        00103f41 00              ??         00h
        00103f42 00              ??         00h
        00103f43 00              ??         00h
        00103f44 00              ??         00h
        00103f45 00              ??         00h
        00103f46 00              ??         00h
        00103f47 00              ??         00h
        00103f48 00              ??         00h
        00103f49 00              ??         00h
        00103f4a 00              ??         00h
        00103f4b 00              ??         00h
        00103f4c 00              ??         00h
        00103f4d 00              ??         00h
        00103f4e 00              ??         00h
        00103f4f 00              ??         00h
        00103f50 00              ??         00h
        00103f51 00              ??         00h
        00103f52 00              ??         00h
        00103f53 00              ??         00h
        00103f54 00              ??         00h
        00103f55 00              ??         00h
        00103f56 00              ??         00h
        00103f57 00              ??         00h
        00103f58 00              ??         00h
        00103f59 00              ??         00h
        00103f5a 00              ??         00h
        00103f5b 00              ??         00h
        00103f5c 00              ??         00h
        00103f5d 00              ??         00h
        00103f5e 00              ??         00h
        00103f5f 00              ??         00h
        00103f60 00              ??         00h
        00103f61 00              ??         00h
        00103f62 00              ??         00h
        00103f63 00              ??         00h
        00103f64 00              ??         00h
        00103f65 00              ??         00h
        00103f66 00              ??         00h
        00103f67 00              ??         00h
                             //
                             // .got 
                             // SHT_PROGBITS  [0x3f68 - 0x3fff]
                             // ram:00103f68-ram:00103fff
                             //
                             __DT_PLTGOT                                     XREF[2]:     00103e50(*), 
                             _GLOBAL_OFFSET_TABLE_                                        _elfSectionHeaders::00000610(*)  
        00103f68 78 3d 10        addr       _DYNAMIC
                 00 00 00 
                 00 00
                             PTR_00103f70                                    XREF[1]:     FUN_00101020:00101020(R)  
        00103f70 00 00 00        addr       00000000
                 00 00 00 
                 00 00
                             PTR_00103f78                                    XREF[1]:     FUN_00101020:00101026  
        00103f78 00 00 00        addr       00000000
                 00 00 00 
                 00 00
                             PTR_putchar_00103f80                            XREF[1]:     putchar:001010f4  
        00103f80 00 50 10        addr       <EXTERNAL>::putchar                              = ??
                 00 00 00 
                 00 00
                             PTR_fclose_00103f88                             XREF[1]:     fclose:00101104  
        00103f88 18 50 10        addr       <EXTERNAL>::fclose                               = ??
                 00 00 00 
                 00 00
                             PTR_strlen_00103f90                             XREF[1]:     strlen:00101114  
        00103f90 20 50 10        addr       <EXTERNAL>::strlen                               = ??
                 00 00 00 
                 00 00
                             PTR___stack_chk_fail_00103f98                   XREF[1]:     __stack_chk_fail:00101124  
        00103f98 28 50 10        addr       <EXTERNAL>::__stack_chk_fail                     = ??
                 00 00 00 
                 00 00
                             PTR_system_00103fa0                             XREF[1]:     system:00101134  
        00103fa0 30 50 10        addr       <EXTERNAL>::system                               = ??
                 00 00 00 
                 00 00
                             PTR_fgets_00103fa8                              XREF[1]:     fgets:00101144  
        00103fa8 38 50 10        addr       <EXTERNAL>::fgets                                = ??
                 00 00 00 
                 00 00
                             PTR_strcmp_00103fb0                             XREF[1]:     strcmp:00101154  
        00103fb0 40 50 10        addr       <EXTERNAL>::strcmp                               = ??
                 00 00 00 
                 00 00
                             PTR_fflush_00103fb8                             XREF[1]:     fflush:00101164  
        00103fb8 50 50 10        addr       <EXTERNAL>::fflush                               = ??
                 00 00 00 
                 00 00
                             PTR_fopen_00103fc0                              XREF[1]:     fopen:00101174  
        00103fc0 58 50 10        addr       <EXTERNAL>::fopen                                = ??
                 00 00 00 
                 00 00
                             PTR___isoc99_scanf_00103fc8                     XREF[1]:     __isoc99_scanf:00101184  
        00103fc8 60 50 10        addr       <EXTERNAL>::__isoc99_scanf                       = ??
                 00 00 00 
                 00 00
                             PTR_usleep_00103fd0                             XREF[1]:     usleep:00101194  
        00103fd0 70 50 10        addr       <EXTERNAL>::usleep                               = ??
                 00 00 00 
                 00 00
                             PTR___libc_start_main_00103fd8                  XREF[1]:     _start:001011bf(R)  
        00103fd8 08 50 10        addr       <EXTERNAL>::__libc_start_main                    = ??
                 00 00 00 
                 00 00
                             PTR__ITM_deregisterTMCloneTable_00103fe0        XREF[1]:     deregister_tm_clones:001011e3(R)  
        00103fe0 10 50 10        addr       <EXTERNAL>::_ITM_deregisterTMCloneTable          = ??
                 00 00 00 
                 00 00
                             PTR___gmon_start___00103fe8                     XREF[1]:     _init:00101008(R)  
        00103fe8 48 50 10        addr       <EXTERNAL>::__gmon_start__                       = ??
                 00 00 00 
                 00 00
                             PTR__ITM_registerTMCloneTable_00103ff0          XREF[1]:     register_tm_clones:00101224(R)  
        00103ff0 68 50 10        addr       <EXTERNAL>::_ITM_registerTMCloneTable            = ??
                 00 00 00 
                 00 00
                             PTR___cxa_finalize_00103ff8                     XREF[2]:     FUN_001010e0:001010e4, 
                                                                                          __do_global_dtors_aux:0010124e(R
        00103ff8 78 50 10        addr       <EXTERNAL>::__cxa_finalize                       = ??
                 00 00 00 
                 00 00
                             //
                             // .data 
                             // SHT_PROGBITS  [0x4000 - 0x4015]
                             // ram:00104000-ram:00104015
                             //
                             __data_start                                    XREF[2]:     Entry Point(*), 
                             data_start                                                   _elfSectionHeaders::00000650(*)  
        00104000 00              ??         00h
        00104001 00              ??         00h
        00104002 00              ??         00h
        00104003 00              ??         00h
        00104004 00              ??         00h
        00104005 00              ??         00h
        00104006 00              ??         00h
        00104007 00              ??         00h
                             __dso_handle                                    XREF[3]:     Entry Point(*), 
                                                                                          __do_global_dtors_aux:0010125b(R
                                                                                          00104008(*)  
        00104008 08 40 10        addr       __dso_handle                                     = 00104008
                 00 00 00 
                 00 00
                             password                                        XREF[41]:    Entry Point(*), one:001016fd(*), 
                                                                                          one:00101704(*), one:00101708(*), 
                                                                                          one:00101710(*), 
                                                                                          three:00101873(*), 
                                                                                          three:0010187a(*), 
                                                                                          three:0010187e(*), 
                                                                                          three:00101886(*), 
                                                                                          five:001019e9(*), 
                                                                                          five:001019f0(*), 
                                                                                          five:001019f4(*), 
                                                                                          five:001019fc(*), 
                                                                                          eight:00101b5f(*), 
                                                                                          eight:00101b66(*), 
                                                                                          eight:00101b6a(*), 
                                                                                          eight:00101b72(*), 
                                                                                          ten:00101cd5(*), ten:00101cdc(*), 
                                                                                          ten:00101ce0(*), [more]
        00104010 70 67 65        ds         "pge2j"
                 32 6a 00
                             //
                             // .bss 
                             // SHT_NOBITS  [0x4020 - 0x403f]
                             // ram:00104020-ram:0010403f
                             //
                             stdout@GLIBC_2.2.5                              XREF[3]:     Entry Point(*), type:001015ad(R), 
                             stdout                                                       _elfSectionHeaders::00000690(*)  
        00104020 00 00 00        undefined8 0000000000000000h
                 00 00 00 
                 00 00
        00104028 00              ??         00h
        00104029 00              ??         00h
        0010402a 00              ??         00h
        0010402b 00              ??         00h
        0010402c 00              ??         00h
        0010402d 00              ??         00h
        0010402e 00              ??         00h
        0010402f 00              ??         00h
                             stdin@GLIBC_2.2.5                               XREF[12]:    Entry Point(*), loop:001012f1(R), 
                             stdin                                                        zero:00101609(R), 
                                                                                          one:001016c4(R), two:0010177f(R), 
                                                                                          three:0010183a(R), 
                                                                                          four:001018f5(R), 
                                                                                          five:001019b0(R), 
                                                                                          six:00101a6b(R), 
                                                                                          eight:00101b26(R), 
                                                                                          nine:00101be1(R), 
                                                                                          ten:00101c9c(R)  
        00104030 00 00 00        undefined8 0000000000000000h
                 00 00 00 
                 00 00
                             completed.0                                     XREF[2]:     __do_global_dtors_aux:00101244(R
                                                                                          __do_global_dtors_aux:0010126c(W
        00104038 00              undefined1 00h
        00104039 00              ??         00h
        0010403a 00              ??         00h
        0010403b 00              ??         00h
        0010403c 00              ??         00h
        0010403d 00              ??         00h
        0010403e 00              ??         00h
        0010403f 00              ??         00h
                             //
                             // EXTERNAL 
                             // NOTE: This block is artificial and allows ELF Relocations 
                             // ram:00105000-ram:0010507f
                             //
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk int putchar(int __c)
                               Thunked-Function: <EXTERNAL>::putchar
             int               EAX:4          <RETURN>
             int               EDI:4          __c
                             putchar@GLIBC_2.2.5
                             <EXTERNAL>::putchar                             XREF[2]:     putchar:001010f0(T), 
                                                                                          putchar:001010f4(c), 00103f80(*)  
        00105000                 ??         ??
        00105001                 ??         ??
        00105002                 ??         ??
        00105003                 ??         ??
        00105004                 ??         ??
        00105005                 ??         ??
        00105006                 ??         ??
        00105007                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk undefined __libc_start_main()
                               Thunked-Function: <EXTERNAL>::__libc_star
             undefined         AL:1           <RETURN>
                             __libc_start_main@GLIBC_2.34
                             <EXTERNAL>::__libc_start_main                   XREF[2]:     _start:001011bf(c), 00103fd8(*)  
        00105008                 ??         ??
        00105009                 ??         ??
        0010500a                 ??         ??
        0010500b                 ??         ??
        0010500c                 ??         ??
        0010500d                 ??         ??
        0010500e                 ??         ??
        0010500f                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk undefined _ITM_deregisterTMCloneTable()
                               Thunked-Function: <EXTERNAL>::_ITM_deregi
             undefined         AL:1           <RETURN>
                             <EXTERNAL>::_ITM_deregisterTMCloneTable         XREF[3]:     deregister_tm_clones:001011e3(*), 
                                                                                          deregister_tm_clones:001011ef(c), 
                                                                                          00103fe0(*)  
        00105010                 ??         ??
        00105011                 ??         ??
        00105012                 ??         ??
        00105013                 ??         ??
        00105014                 ??         ??
        00105015                 ??         ??
        00105016                 ??         ??
        00105017                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk int fclose(FILE * __stream)
                               Thunked-Function: <EXTERNAL>::fclose
             int               EAX:4          <RETURN>
             FILE *            RDI:8          __stream
                             fclose@GLIBC_2.2.5
                             <EXTERNAL>::fclose                              XREF[2]:     fclose:00101100(T), 
                                                                                          fclose:00101104(c), 00103f88(*)  
        00105018                 ??         ??
        00105019                 ??         ??
        0010501a                 ??         ??
        0010501b                 ??         ??
        0010501c                 ??         ??
        0010501d                 ??         ??
        0010501e                 ??         ??
        0010501f                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk size_t strlen(char * __s)
                               Thunked-Function: <EXTERNAL>::strlen
             size_t            RAX:8          <RETURN>
             char *            RDI:8          __s
                             strlen@GLIBC_2.2.5
                             <EXTERNAL>::strlen                              XREF[2]:     strlen:00101110(T), 
                                                                                          strlen:00101114(c), 00103f90(*)  
        00105020                 ??         ??
        00105021                 ??         ??
        00105022                 ??         ??
        00105023                 ??         ??
        00105024                 ??         ??
        00105025                 ??         ??
        00105026                 ??         ??
        00105027                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk noreturn undefined __stack_chk_fail()
                               Thunked-Function: <EXTERNAL>::__stack_chk
             undefined         AL:1           <RETURN>
                             __stack_chk_fail@GLIBC_2.4
                             <EXTERNAL>::__stack_chk_fail                    XREF[2]:     __stack_chk_fail:00101120(T), 
                                                                                          __stack_chk_fail:00101124(c), 
                                                                                          00103f98(*)  
        00105028                 ??         ??
        00105029                 ??         ??
        0010502a                 ??         ??
        0010502b                 ??         ??
        0010502c                 ??         ??
        0010502d                 ??         ??
        0010502e                 ??         ??
        0010502f                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk int system(char * __command)
                               Thunked-Function: <EXTERNAL>::system
             int               EAX:4          <RETURN>
             char *            RDI:8          __command
                             system@GLIBC_2.2.5
                             <EXTERNAL>::system                              XREF[2]:     system:00101130(T), 
                                                                                          system:00101134(c), 00103fa0(*)  
        00105030                 ??         ??
        00105031                 ??         ??
        00105032                 ??         ??
        00105033                 ??         ??
        00105034                 ??         ??
        00105035                 ??         ??
        00105036                 ??         ??
        00105037                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk char * fgets(char * __s, int __n, FILE * __stream)
                               Thunked-Function: <EXTERNAL>::fgets
             char *            RAX:8          <RETURN>
             char *            RDI:8          __s
             int               ESI:4          __n
             FILE *            RDX:8          __stream
                             fgets@GLIBC_2.2.5
                             <EXTERNAL>::fgets                               XREF[2]:     fgets:00101140(T), 
                                                                                          fgets:00101144(c), 00103fa8(*)  
        00105038                 ??         ??
        00105039                 ??         ??
        0010503a                 ??         ??
        0010503b                 ??         ??
        0010503c                 ??         ??
        0010503d                 ??         ??
        0010503e                 ??         ??
        0010503f                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk int strcmp(char * __s1, char * __s2)
                               Thunked-Function: <EXTERNAL>::strcmp
             int               EAX:4          <RETURN>
             char *            RDI:8          __s1
             char *            RSI:8          __s2
                             strcmp@GLIBC_2.2.5
                             <EXTERNAL>::strcmp                              XREF[2]:     strcmp:00101150(T), 
                                                                                          strcmp:00101154(c), 00103fb0(*)  
        00105040                 ??         ??
        00105041                 ??         ??
        00105042                 ??         ??
        00105043                 ??         ??
        00105044                 ??         ??
        00105045                 ??         ??
        00105046                 ??         ??
        00105047                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk undefined __gmon_start__()
                               Thunked-Function: <EXTERNAL>::__gmon_star
             undefined         AL:1           <RETURN>
                             <EXTERNAL>::__gmon_start__                      XREF[3]:     _init:00101008(*), 
                                                                                          _init:00101014(c), 00103fe8(*)  
        00105048                 ??         ??
        00105049                 ??         ??
        0010504a                 ??         ??
        0010504b                 ??         ??
        0010504c                 ??         ??
        0010504d                 ??         ??
        0010504e                 ??         ??
        0010504f                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk int fflush(FILE * __stream)
                               Thunked-Function: <EXTERNAL>::fflush
             int               EAX:4          <RETURN>
             FILE *            RDI:8          __stream
                             fflush@GLIBC_2.2.5
                             <EXTERNAL>::fflush                              XREF[2]:     fflush:00101160(T), 
                                                                                          fflush:00101164(c), 00103fb8(*)  
        00105050                 ??         ??
        00105051                 ??         ??
        00105052                 ??         ??
        00105053                 ??         ??
        00105054                 ??         ??
        00105055                 ??         ??
        00105056                 ??         ??
        00105057                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk FILE * fopen(char * __filename, char * __modes)
                               Thunked-Function: <EXTERNAL>::fopen
             FILE *            RAX:8          <RETURN>
             char *            RDI:8          __filename
             char *            RSI:8          __modes
                             fopen@GLIBC_2.2.5
                             <EXTERNAL>::fopen                               XREF[2]:     fopen:00101170(T), 
                                                                                          fopen:00101174(c), 00103fc0(*)  
        00105058                 ??         ??
        00105059                 ??         ??
        0010505a                 ??         ??
        0010505b                 ??         ??
        0010505c                 ??         ??
        0010505d                 ??         ??
        0010505e                 ??         ??
        0010505f                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk undefined __isoc99_scanf()
                               Thunked-Function: <EXTERNAL>::__isoc99_sc
             undefined         AL:1           <RETURN>
                             __isoc99_scanf@GLIBC_2.7
                             <EXTERNAL>::__isoc99_scanf                      XREF[2]:     __isoc99_scanf:00101180(T), 
                                                                                          __isoc99_scanf:00101184(c), 
                                                                                          00103fc8(*)  
        00105060                 ??         ??
        00105061                 ??         ??
        00105062                 ??         ??
        00105063                 ??         ??
        00105064                 ??         ??
        00105065                 ??         ??
        00105066                 ??         ??
        00105067                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk undefined _ITM_registerTMCloneTable()
                               Thunked-Function: <EXTERNAL>::_ITM_regist
             undefined         AL:1           <RETURN>
                             <EXTERNAL>::_ITM_registerTMCloneTable           XREF[3]:     register_tm_clones:00101224(*), 
                                                                                          register_tm_clones:00101230(c), 
                                                                                          00103ff0(*)  
        00105068                 ??         ??
        00105069                 ??         ??
        0010506a                 ??         ??
        0010506b                 ??         ??
        0010506c                 ??         ??
        0010506d                 ??         ??
        0010506e                 ??         ??
        0010506f                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk int usleep(__useconds_t __useconds)
                               Thunked-Function: <EXTERNAL>::usleep
             int               EAX:4          <RETURN>
             __useconds_t      EDI:4          __useconds
                             usleep@GLIBC_2.2.5
                             <EXTERNAL>::usleep                              XREF[2]:     usleep:00101190(T), 
                                                                                          usleep:00101194(c), 00103fd0(*)  
        00105070                 ??         ??
        00105071                 ??         ??
        00105072                 ??         ??
        00105073                 ??         ??
        00105074                 ??         ??
        00105075                 ??         ??
        00105076                 ??         ??
        00105077                 ??         ??
                             **************************************************************
                             *                       THUNK FUNCTION                       *
                             **************************************************************
                             thunk undefined __cxa_finalize()
                               Thunked-Function: <EXTERNAL>::__cxa_final
             undefined         AL:1           <RETURN>
                             __cxa_finalize@GLIBC_2.2.5
                             <EXTERNAL>::__cxa_finalize                      XREF[2]:     FUN_001010e0:001010e4(c), 
                                                                                          00103ff8(*)  
        00105078                 ??         ??
        00105079                 ??         ??
        0010507a                 ??         ??
        0010507b                 ??         ??
        0010507c                 ??         ??
        0010507d                 ??         ??
        0010507e                 ??         ??
        0010507f                 ??         ??
                             //
                             // .comment 
                             // SHT_PROGBITS [not-loaded]
                             // .comment::00000000-.comment::0000002a
                             //
             assume DF = <UNKNOWN>
                             ElfComment[0]                                   XREF[1]:     _elfSectionHeaders::000006d0(*)  
     t::00000000 47 43 43        utf8       u8"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
                 3a 20 28 
                 55 62 75 
                             //
                             // .shstrtab 
                             // SHT_STRTAB [not-loaded]
                             // .shstrtab::00000000-.shstrtab::00000119
                             //
                             DAT_.shstrtab__00000000                         XREF[1]:     _elfSectionHeaders::00000790(*)  
     b::00000000 00              ??         00h
     b::00000001 2e 73 79        utf8       u8".symtab"
                 6d 74 61 
                 62 00
     b::00000009 2e 73 74        utf8       u8".strtab"
                 72 74 61 
                 62 00
     b::00000011 2e 73 68        utf8       u8".shstrtab"
                 73 74 72 
                 74 61 62 00
     b::0000001b 2e 69 6e        utf8       u8".interp"
                 74 65 72 
                 70 00
     b::00000023 2e 6e 6f        utf8       u8".note.gnu.property"
                 74 65 2e 
                 67 6e 75 
     b::00000036 2e 6e 6f        utf8       u8".note.gnu.build-id"
                 74 65 2e 
                 67 6e 75 
     b::00000049 2e 6e 6f        utf8       u8".note.ABI-tag"
                 74 65 2e 
                 41 42 49 
     b::00000057 2e 67 6e        utf8       u8".gnu.hash"
                 75 2e 68 
                 61 73 68 00
     b::00000061 2e 64 79        utf8       u8".dynsym"
                 6e 73 79 
                 6d 00
     b::00000069 2e 64 79        utf8       u8".dynstr"
                 6e 73 74 
                 72 00
     b::00000071 2e 67 6e        utf8       u8".gnu.version"
                 75 2e 76 
                 65 72 73 
     b::0000007e 2e 67 6e        utf8       u8".gnu.version_r"
                 75 2e 76 
                 65 72 73 
     b::0000008d 2e 72 65        utf8       u8".rela.dyn"
                 6c 61 2e 
                 64 79 6e 00
     b::00000097 2e 72 65        utf8       u8".rela.plt"
                 6c 61 2e 
                 70 6c 74 00
     b::000000a1 2e 69 6e        utf8       u8".init"
                 69 74 00
     b::000000a7 2e 70 6c        utf8       u8".plt.got"
                 74 2e 67 
                 6f 74 00
     b::000000b0 2e 70 6c        utf8       u8".plt.sec"
                 74 2e 73 
                 65 63 00
     b::000000b9 2e 74 65        utf8       u8".text"
                 78 74 00
     b::000000bf 2e 66 69        utf8       u8".fini"
                 6e 69 00
     b::000000c5 2e 72 6f        utf8       u8".rodata"
                 64 61 74 
                 61 00
     b::000000cd 2e 65 68        utf8       u8".eh_frame_hdr"
                 5f 66 72 
                 61 6d 65 
     b::000000db 2e 65 68        utf8       u8".eh_frame"
                 5f 66 72 
                 61 6d 65 00
     b::000000e5 2e 69 6e        utf8       u8".init_array"
                 69 74 5f 
                 61 72 72 
     b::000000f1 2e 66 69        utf8       u8".fini_array"
                 6e 69 5f 
                 61 72 72 
     b::000000fd 2e 64 79        utf8       u8".dynamic"
                 6e 61 6d 
                 69 63 00
     b::00000106 2e 64 61        utf8       u8".data"
                 74 61 00
     b::0000010c 2e 62 73        utf8       u8".bss"
                 73 00
     b::00000111 2e 63 6f        utf8       u8".comment"
                 6d 6d 65 
                 6e 74 00
                             //
                             // .strtab 
                             // SHT_STRTAB [not-loaded]
                             // .strtab::00000000-.strtab::00000325
                             //
                             DAT_.strtab__00000000                           XREF[1]:     _elfSectionHeaders::00000750(*)  
     b::00000000 00              ??         00h
     b::00000001 53 63 72        utf8       u8"Scrt1.o"
                 74 31 2e 
                 6f 00
     b::00000009 5f 5f 61        utf8       u8"__abi_tag"
                 62 69 5f 
                 74 61 67 00
     b::00000013 63 72 74        utf8       u8"crtstuff.c"
                 73 74 75 
                 66 66 2e 
     b::0000001e 64 65 72        utf8       u8"deregister_tm_clones"
                 65 67 69 
                 73 74 65 
     b::00000033 5f 5f 64        utf8       u8"__do_global_dtors_aux"
                 6f 5f 67 
                 6c 6f 62 
     b::00000049 63 6f 6d        utf8       u8"completed.0"
                 70 6c 65 
                 74 65 64 
     b::00000055 5f 5f 64        utf8       u8"__do_global_dtors_aux_fini_array_entry"
                 6f 5f 67 
                 6c 6f 62 
     b::0000007c 66 72 61        utf8       u8"frame_dummy"
                 6d 65 5f 
                 64 75 6d 
     b::00000088 5f 5f 66        utf8       u8"__frame_dummy_init_array_entry"
                 72 61 6d 
                 65 5f 64 
     b::000000a7 63 6f 6e        utf8       u8"confusing-code.c"
                 66 75 73 
                 69 6e 67 
     b::000000b8 5f 5f 46        utf8       u8"__FRAME_END__"
                 52 41 4d 
                 45 5f 45 
     b::000000c6 5f 44 59        utf8       u8"_DYNAMIC"
                 4e 41 4d 
                 49 43 00
     b::000000cf 5f 5f 47        utf8       u8"__GNU_EH_FRAME_HDR"
                 4e 55 5f 
                 45 48 5f 
     b::000000e2 5f 47 4c        utf8       u8"_GLOBAL_OFFSET_TABLE_"
                 4f 42 41 
                 4c 5f 4f 
     b::000000f8 74 77 6f 00     utf8       u8"two"
     b::000000fc 66 69 76        utf8       u8"five"
                 65 00
     b::00000101 70 75 74        utf8       u8"putchar@GLIBC_2.2.5"
                 63 68 61 
                 72 40 47 
     b::00000115 5f 5f 6c        utf8       u8"__libc_start_main@GLIBC_2.34"
                 69 62 63 
                 5f 73 74 
     b::00000132 5f 49 54        utf8       u8"_ITM_deregisterTMCloneTable"
                 4d 5f 64 
                 65 72 65 
     b::0000014e 73 74 64        utf8       u8"stdout@GLIBC_2.2.5"
                 6f 75 74 
                 40 47 4c 
     b::00000161 6e 69 6e        utf8       u8"nine"
                 65 00
     b::00000166 74 79 70        utf8       u8"type"
                 65 00
     b::0000016b 73 74 64        utf8       u8"stdin@GLIBC_2.2.5"
                 69 6e 40 
                 47 4c 49 
     b::0000017d 6c 6f 6f        utf8       u8"loop"
                 70 00
     b::00000182 5f 65 64        utf8       u8"_edata"
                 61 74 61 00
     b::00000189 66 63 6c        utf8       u8"fclose@GLIBC_2.2.5"
                 6f 73 65 
                 40 47 4c 
     b::0000019c 5f 66 69        utf8       u8"_fini"
                 6e 69 00
     b::000001a2 65 6c 65        utf8       u8"eleven"
                 76 65 6e 00
     b::000001a9 73 74 72        utf8       u8"strlen@GLIBC_2.2.5"
                 6c 65 6e 
                 40 47 4c 
     b::000001bc 5f 5f 73        utf8       u8"__stack_chk_fail@GLIBC_2.4"
                 74 61 63 
                 6b 5f 63 
     b::000001d7 73 79 73        utf8       u8"system@GLIBC_2.2.5"
                 74 65 6d 
                 40 47 4c 
     b::000001ea 74 65 6e 00     utf8       u8"ten"
     b::000001ee 70 61 73        utf8       u8"password"
                 73 77 6f 
                 72 64 00
     b::000001f7 73 69 78 00     utf8       u8"six"
     b::000001fb 66 67 65        utf8       u8"fgets@GLIBC_2.2.5"
                 74 73 40 
                 47 4c 49 
     b::0000020d 5f 5f 64        utf8       u8"__data_start"
                 61 74 61 
                 5f 73 74 
     b::0000021a 73 74 72        utf8       u8"strcmp@GLIBC_2.2.5"
                 63 6d 70 
                 40 47 4c 
     b::0000022d 5f 5f 67        utf8       u8"__gmon_start__"
                 6d 6f 6e 
                 5f 73 74 
     b::0000023c 5f 5f 64        utf8       u8"__dso_handle"
                 73 6f 5f 
                 68 61 6e 
     b::00000249 5f 49 4f        utf8       u8"_IO_stdin_used"
                 5f 73 74 
                 64 69 6e 
     b::00000258 65 69 67        utf8       u8"eight"
                 68 74 00
     b::0000025e 66 66 6c        utf8       u8"fflush@GLIBC_2.2.5"
                 75 73 68 
                 40 47 4c 
     b::00000271 5f 65 6e        utf8       u8"_end"
                 64 00
     b::00000276 7a 65 72        utf8       u8"zero"
                 6f 00
     b::0000027b 66 6f 75        utf8       u8"four"
                 72 00
     b::00000280 6f 6e 65 00     utf8       u8"one"
     b::00000284 5f 5f 62        utf8       u8"__bss_start"
                 73 73 5f 
                 73 74 61 
     b::00000290 6d 61 69        utf8       u8"main"
                 6e 00
     b::00000295 74 68 72        utf8       u8"three"
                 65 65 00
     b::0000029b 73 65 76        utf8       u8"seven"
                 65 6e 00
     b::000002a1 66 6f 70        utf8       u8"fopen@GLIBC_2.2.5"
                 65 6e 40 
                 47 4c 49 
     b::000002b3 5f 5f 69        utf8       u8"__isoc99_scanf@GLIBC_2.7"
                 73 6f 63 
                 39 39 5f 
     b::000002cc 5f 5f 54        utf8       u8"__TMC_END__"
                 4d 43 5f 
                 45 4e 44 
     b::000002d8 5f 49 54        utf8       u8"_ITM_registerTMCloneTable"
                 4d 5f 72 
                 65 67 69 
     b::000002f2 5f 5f 63        utf8       u8"__cxa_finalize@GLIBC_2.2.5"
                 78 61 5f 
                 66 69 6e 
     b::0000030d 5f 69 6e        utf8       u8"_init"
                 69 74 00
     b::00000313 75 73 6c        utf8       u8"usleep@GLIBC_2.2.5"
                 65 65 70 
                 40 47 4c 
                             //
                             // .symtab 
                             // SHT_SYMTAB [not-loaded]
                             // .symtab::00000000-.symtab::000005e7
                             //
                             Elf64_Sym_ARRAY_.symtab__00000000               XREF[1]:     _elfSectionHeaders::00000710(*)  
     b::00000000 00 00 00        Elf64_Sy
                 00 00 00 
                 00 00 00 
                             //
                             // _elfSectionHeaders 
                             // Elf Section Headers
                             // _elfSectionHeaders::00000000-_elfSectionHeaders::000007bf
                             //
                             Elf64_Shdr_ARRAY__elfSectionHeaders__00000000   XREF[1]:     00100028(*)  
     s::00000000 00 00 00        Elf64_Sh                                                    SECTION0 - SHT_NULL
                 00 00 00 
                 00 00 00 
