################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
/Users/Sinnto/CS61C/proj1-cx-nq/assembler.c \
/Users/Sinnto/CS61C/proj1-cx-nq/test_assembler.c 

OBJS += \
./assembler.o \
./test_assembler.o 

C_DEPS += \
./assembler.d \
./test_assembler.d 


# Each subdirectory must supply rules for building sources it contributes
assembler.o: /Users/Sinnto/CS61C/proj1-cx-nq/assembler.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

test_assembler.o: /Users/Sinnto/CS61C/proj1-cx-nq/test_assembler.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


