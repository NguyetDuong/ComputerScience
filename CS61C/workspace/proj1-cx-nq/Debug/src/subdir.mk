################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
/Users/Sinnto/CS61C/proj1-cx-nq/src/tables.c \
/Users/Sinnto/CS61C/proj1-cx-nq/src/translate.c \
/Users/Sinnto/CS61C/proj1-cx-nq/src/translate_utils.c \
/Users/Sinnto/CS61C/proj1-cx-nq/src/utils.c 

OBJS += \
./src/tables.o \
./src/translate.o \
./src/translate_utils.o \
./src/utils.o 

C_DEPS += \
./src/tables.d \
./src/translate.d \
./src/translate_utils.d \
./src/utils.d 


# Each subdirectory must supply rules for building sources it contributes
src/tables.o: /Users/Sinnto/CS61C/proj1-cx-nq/src/tables.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/translate.o: /Users/Sinnto/CS61C/proj1-cx-nq/src/translate.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/translate_utils.o: /Users/Sinnto/CS61C/proj1-cx-nq/src/translate_utils.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/utils.o: /Users/Sinnto/CS61C/proj1-cx-nq/src/utils.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


