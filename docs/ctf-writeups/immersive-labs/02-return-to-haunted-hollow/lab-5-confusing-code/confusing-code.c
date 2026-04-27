
void type(char *param_1)

{
  size_t sVar1;
  int local_1c;
  
  local_1c = 0;
  while( true ) {
    sVar1 = strlen(param_1);
    if (sVar1 <= (ulong)(long)local_1c) break;
    putchar((int)param_1[local_1c]);
    fflush(stdout);
    usleep(20000);
    local_1c = local_1c + 1;
  }
  return;
}


undefined8 zero(void)

{
  int iVar1;
  undefined8 uVar2;
  long in_FS_OFFSET;
  char local_28 [24];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  fflush(stdin);
  type("What is the passcode to the computer?: ");
  __isoc99_scanf(&DAT_00102280,local_28);
  iVar1 = strcmp(local_28,password);
  if (iVar1 == 0) {
    uVar2 = seven(1);
  }
  else {
    system("clear");
    type(
        "There seems to have been a mix up, you\'ve entered the wrong password, have a look at what the input is compared to and try again...\n\n"
        );
    uVar2 = 0;
  }
  if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return uVar2;
}


undefined8 two(void)

{
  int iVar1;
  undefined8 uVar2;
  long in_FS_OFFSET;
  char local_28 [24];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  fflush(stdin);
  type("What is the passcode to the computer?: ");
  __isoc99_scanf(&DAT_00102280,local_28);
  iVar1 = strcmp(local_28,password);
  if (iVar1 == 0) {
    uVar2 = seven(1);
  }
  else {
    system("clear");
    type(
        "There seems to have been a mix up, you\'ve entered the wrong password, have a look at what the input is compared to and try again...\n\n"
        );
    uVar2 = 0;
  }
  if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return uVar2;
}


undefined8 three(void)

{
  int iVar1;
  undefined8 uVar2;
  long in_FS_OFFSET;
  char local_28 [24];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  fflush(stdin);
  type("What is the passcode to the computer?: ");
  __isoc99_scanf(&DAT_00102280,local_28);
  iVar1 = strcmp(local_28,password);
  if (iVar1 == 0) {
    uVar2 = seven(0);
  }
  else {
    system("clear");
    type(
        "There seems to have been a mix up, you\'ve entered the wrong password, have a look at what the input is compared to and try again...\n\n"
        );
    uVar2 = 0;
  }
  if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return uVar2;
}


undefined8 four(void)

{
  int iVar1;
  undefined8 uVar2;
  long in_FS_OFFSET;
  char local_28 [24];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  fflush(stdin);
  type("What is the passcode to the computer?: ");
  __isoc99_scanf(&DAT_00102280,local_28);
  iVar1 = strcmp(local_28,password);
  if (iVar1 == 0) {
    uVar2 = seven(1);
  }
  else {
    system("clear");
    type(
        "There seems to have been a mix up, you\'ve entered the wrong password, have a look at what the input is compared to and try again...\n\n"
        );
    uVar2 = 0;
  }
  if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return uVar2;
}


undefined8 five(void)

{
  int iVar1;
  undefined8 uVar2;
  long in_FS_OFFSET;
  char local_28 [24];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  fflush(stdin);
  type("What is the passcode to the computer?: ");
  __isoc99_scanf(&DAT_00102280,local_28);
  iVar1 = strcmp(local_28,password);
  if (iVar1 == 0) {
    uVar2 = seven(1);
  }
  else {
    system("clear");
    type(
        "There seems to have been a mix up, you\'ve entered the wrong password, have a look at what the input is compared to and try again...\n\n"
        );
    uVar2 = 0;
  }
  if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return uVar2;
}


undefined8 six(void)

{
  int iVar1;
  undefined8 uVar2;
  long in_FS_OFFSET;
  char local_28 [24];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  fflush(stdin);
  type("What is the passcode to the computer?: ");
  __isoc99_scanf(&DAT_00102280,local_28);
  iVar1 = strcmp(local_28,password);
  if (iVar1 == 0) {
    uVar2 = seven(1);
  }
  else {
    system("clear");
    type(
        "There seems to have been a mix up, you\'ve entered the wrong password, have a look at what the input is compared to and try again...\n\n"
        );
    uVar2 = 0;
  }
  if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return uVar2;
}


undefined8 seven(char param_1)

{
  FILE *__stream;
  undefined8 uVar1;
  long in_FS_OFFSET;
  char local_28 [24];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  if (param_1 == '\x01') {
    system("clear");
    type(
        "There seems to have been a mix up, you can\'t find the access code - are you at the correct  ride? See if you can find the function that is slightly different then try again...\n\n"
        );
    uVar1 = 0;
  }
  else {
    __stream = fopen("/root/token.txt","r");
    if (__stream == (FILE *)0x0) {
      system("clear");
      type("Error opening file - do you have permission to open the token? Try running with sudo.\n"
          );
    }
    else {
      type(
          "You go to the correct ride and unlock the computer there with the correct password, it un locks revealing the access code to you: "
          );
      fgets(local_28,0x14,__stream);
      type(local_28);
    }
    fclose(__stream);
    uVar1 = 1;
  }
  if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return uVar1;
}


undefined8 eight(void)

{
  int iVar1;
  undefined8 uVar2;
  long in_FS_OFFSET;
  char local_28 [24];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  fflush(stdin);
  type("What is the passcode to the computer?: ");
  __isoc99_scanf(&DAT_00102280,local_28);
  iVar1 = strcmp(local_28,password);
  if (iVar1 == 0) {
    uVar2 = seven(1);
  }
  else {
    system("clear");
    type(
        "There seems to have been a mix up, you\'ve entered the wrong password, have a look at what the input is compared to and try again...\n\n"
        );
    uVar2 = 0;
  }
  if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return uVar2;
}


undefined8 nine(void)

{
  int iVar1;
  undefined8 uVar2;
  long in_FS_OFFSET;
  char local_28 [24];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  fflush(stdin);
  type("What is the passcode to the computer?: ");
  __isoc99_scanf(&DAT_00102280,local_28);
  iVar1 = strcmp(local_28,password);
  if (iVar1 == 0) {
    uVar2 = seven(1);
  }
  else {
    system("clear");
    type(
        "There seems to have been a mix up, you\'ve entered the wrong password, have a look at what the input is compared to and try again...\n\n"
        );
    uVar2 = 0;
  }
  if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return uVar2;
}


undefined8 ten(void)

{
  int iVar1;
  undefined8 uVar2;
  long in_FS_OFFSET;
  char local_28 [24];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  fflush(stdin);
  type("What is the passcode to the computer?: ");
  __isoc99_scanf(&DAT_00102280,local_28);
  iVar1 = strcmp(local_28,password);
  if (iVar1 == 0) {
    uVar2 = seven(1);
  }
  else {
    system("clear");
    type(
        "There seems to have been a mix up, you\'ve entered the wrong password, have a look at what the input is compared to and try again...\n\n"
        );
    uVar2 = 0;
  }
  if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return uVar2;
}


void eleven(void)

{
  type("Where is the AI\'s access code hidden?\n");
  type(" - In the remains of the Python Pit?\n");
  type(" - In the jaws of the sharks in their pool?\n");
  type(" - In the chaos of the carnival?\n");
  type(" - Under the Rusty Rollercoaster?\n");
  type(" - Somewhere in Mirror Mayhem?\n");
  type(" - In the Cursed Crypt?\n");
  type("Which route do you want to take? - enter the id of the ride (it will be between 0-65535)): "
      );
  return;
}

undefined8 loop(void)

{
    undefined8 uVar1;
    long in_FS_OFFSET;
    int local_14;
    long local_10;

    local_10 = *(long *)(in_FS_OFFSET + 0x28);
    local_14 = 0;
    fflush(stdin);
    eleven();
    __isoc99_scanf(&DAT_00102025, &local_14);
    if (local_14 == 0xffff) {
        uVar1 = ten();
        goto LAB_00101474;
    }
    if (local_14 < 0x10000) {
        if (local_14 == 0x5d60) {
            uVar1 = nine();
            goto LAB_00101474;
        }
        if (local_14 < 0x5d61) {
            if (local_14 == 0x1931) {
                uVar1 = eight();
                goto LAB_00101474;
            }
            if (local_14 < 0x1932) {
                if (local_14 == 0xcab) {
                    uVar1 = six();
                    goto LAB_00101474;
                }
                if (local_14 < 0xcac) {
                    if (local_14 == 0xc73) {
                        uVar1 = five();
                        goto LAB_00101474;
                    }
                    if (local_14 < 0xc74) {
                        if (local_14 == 0x21f) {
                            uVar1 = four();
                            goto LAB_00101474;
                        }
                        if (local_14 < 0x220) {
                            if (local_14 == 0x126) {
                                uVar1 = three();
                                goto LAB_00101474;
                            }
                            if (local_14 < 0x127) {
                                if (local_14 == 0x7c) {
                                    uVar1 = two();
                                    goto LAB_00101474;
                                }
                                if (local_14 < 0x7d) {
                                    if (local_14 == 0) {
                                        uVar1 = zero();
                                        goto LAB_00101474;
                                    }
                                    if (local_14 == 0x1c) {
                                        uVar1 = one();
                                        goto LAB_00101474;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    system("clear");
    type(
        "There seems to have been a mix up, you can\'t find a ride with that id, have a look at the lo op function and try again...\n\n");
    uVar1 = 0;
LAB_00101474:
    if (local_10 == *(long *)(in_FS_OFFSET + 0x28)) {
        return uVar1;
    }
    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
}

undefined8 main(void)

{
    int iVar1;
    bool bVar2;

    type("Welcome doomed investigator\n");
    bVar2 = true;
    while (bVar2) {
        iVar1 = loop();
        bVar2 = iVar1 == 0;
    }
    return 0;
}
