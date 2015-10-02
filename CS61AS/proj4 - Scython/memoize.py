# We pass the 'memoize' function the logic of our recursive procedure, in our example,
# the '__fib' procedure. We then define 'fib_memo' to be the return value from 'memoize(__fib)'.
# This indicates that the 'memoize' procedure must return another procedure! Lets consider the
# 'memoize' procedure further. This function takes in a procedure that it will use to compute
# future values to be memoized. Because the return type from the function 'memoize' is another
# procedure, 'memoize' demonstrates that our python interpreter supports higher order procedures.
# Remember, the point of 'memoize' is to store the return values for a given input of a function.
# If it hasn't seen a given input, 'memoize' should calculate the value for the given input, then
# store it (or memoize it, in memoization parlance). You will find that using dictionaries for this
# assignment will be helpful. As another example of using 'memoize', here is how we want to be
# able to define 'factorial':

#       def __factorial(x, memo):
#         if x <= 1:
#           return x
#         else:
#           return x * memo(x-1)

#       factorial = memoize(__factorial)
#       

# def make_fib_memos():
#         fib_memos = {}
#         def fib(x):
#           if x in fib_memos:     #fibonacci(x) has already been computed, return this value
#             return fib_memos[x]
#           elif x <= 1:
#             return x
#           else:
#             t = fib(x-1) + fib(x-2)
#             fib_memos[x] = t
#             return t
#         return fib

def memoize(originalF):
  remember = {} # create a dictionary that holds all of the calculated and remembered vals
  def createdF(x):
    if x in remember: # check if we already have the input value for whatever "x" is
      return remember[x] #returns the value associated to the word
    else:
      t = originalF(x, createdF) # recursion until it hits its basecase to remember
      remember[x] = t
      return remember[x]
  return createdF






