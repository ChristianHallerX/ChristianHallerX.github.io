---
title: Speedy Python
image: /assets/img/research/SpeedyPython/SpeedyPython_Cover.jpg
description: > 
  Start measuring, find bottlenecks.
---

0. this unordered seed list will be replaced by toc as unordered list
{:toc}


Writing code a programming language is very flexible.
Many solutions will lead you to a goal.
But not all the ways of are equally quick in computation and parsimonious in memory allocation.
For many applications you won't really bother with using speedier commands.
However, this becomes a consideration when dealing with large datasets (aka Big Data) or you prefer to use serverless services that charge by computation time (e.g., AWS Lambdas).
How do we find out what command is more efficient and what is less efficient? You can measure!

# Measurement Tools

- <a href="https://docs.python.org/3/library/timeit.html" target="_blank">Timeit</a>: line magic (`%timeit`) and cell magic (`%%timeit`). Timeit line magic runs only a single line, cell magic uses the entire cell. Benefits of timeit is that repetitions of the command can be scheduled and a more reliable average is delivered.

- <a href="https://github.com/pyutils/line_profiler" target="_blank">Line_Profiler</a>, a module that accepts a function and returns a line-by-line analysis how long each line took to execute and its proportion of overall time. A great way to find bottleneck commands in a function.

- <a href="https://github.com/pythonprofilers/memory_profiler" target="_blank">Memory_Profiler</a>, a memory that accepts a function (imported from a .py file) and delivers a line-by-line analysis of memory usage in MiB. 

If you want to know more about magic commands and code measurement, check out these articles:
- <a href="https://towardsdatascience.com/the-top-5-magic-commands-for-jupyter-notebooks-2bf0c5ae4bb8" target="_blank">The Top 5 Magic Commands for Jupyter Notebooks</a> on Towards Data Science
- <a href="https://jakevdp.github.io/PythonDataScienceHandbook/01.07-timing-and-profiling.html" target="_blank">Profiling and Timing Code</a> in Python Data Science Handbook

An example Jupyter Notebook with all the code of this post can be found <a href="https://github.com/ChristianHallerX/Python_Coding/blob/master/speedy_python/SpeedyPython_measuring.ipynb" target="_blank">**here**</a>
{:.note}


## Timeit

**Line Magic**

Line magic is used for short one-liner measuring.

For the first use, execute `%load_ext line_profiler` to load the module.

Default parameters:

~~~python
%timeit lambda: "-".join(map(str, range(10000)))
~~~
>44 ns ± 1.45 ns per loop (mean ± std. dev. of 7 runs, 10000000 loops each)


Setting flags to set custom parameters for repetitions and number of runs:

~~~python
%timeit -r 10 -n 1000 lambda: "-".join(map(str, range(10000)))
~~~
>40.9 ns ± 0.134 ns per loop (mean ± std. dev. of 10 runs, 1000 loops each)


**Cell Magic**

Cell Magic is used to measure multi-line scripts. The same flags can be set for cell magic.

~~~python
%%timeit
total = 0
for i in range(100):
    for j in range(100):
        total += i * (-1) ** j
~~~
>3.33 ms ± 71.1 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)


## Line Profiler

The Line Profiler offers a total run time and additionally detailed measurements how much time each line took to execute, how many times it was executed, and what proportion of the total each line makes up.

~~~python
%load_ext line_profiler

%lprun -f convert_units_list convert_units_list(nameList, HTList, WTList)
~~~

```
Timer unit: 1e-07 s

Total time: 0.213249 s
File: <ipython-input-7-b143edde93f5>
Function: convert_units_list at line 2

Line #      Hits         Time  Per Hit   % Time  Line Contents
==============================================================
     2                                           def convert_units_list(names, heights, weights):
     3         1     184181.0 184181.0      8.6      new_hts = [ht * 0.39370  for ht in heights]
     4         1     171217.0 171217.0      8.0      new_wts = [wt * 2.20462  for wt in weights]
     5         1         21.0     21.0      0.0      people_data = {}
     6    100001     883878.0      8.8     41.4      for i,name in enumerate(names):
     7    100000     893188.0      8.9     41.9          people_data[name] = (new_hts[i], new_wts[i])
     8         1          7.0      7.0      0.0      return people_data
```


## Memory Profiler


Use and settings of the Memory Profiler is very similar to the Line Profiler.
The "Increment" column shows memory volume gained in each line.
The Memory Profiler only works with functions that are imported from .py files in the working directory!
If the function is too small to measure, it will show “0.0 MiB”.

~~~python
from conv_list import convert_units_list

%load_ext memory_profiler

%mprun -f convert_units_list convert_units_list(nameList, HTList, WTList)
~~~

```
Filename: C:\Users\ChristianV700\Documents\GitHub\Python_coding\speedy_python\conv_list.py

Line #    Mem usage    Increment  Occurences   Line Contents
============================================================
     1     76.8 MiB     76.8 MiB           1   def convert_units_list(names, heights, weights):
     2     81.1 MiB      4.3 MiB      100003       new_hts = [ht * 0.39370  for ht in heights]
     3     85.7 MiB      4.6 MiB      100003       new_wts = [wt * 2.20462  for wt in weights]
     4     85.7 MiB      0.0 MiB           1       people_data = {}
     5     96.9 MiB      6.1 MiB      100001       for i,name in enumerate(names):
     6     96.9 MiB      5.0 MiB      100000           people_data[name] = (new_hts[i], new_wts[i])
     7     96.9 MiB      0.0 MiB           1       return people_data
```

## Timer Decorator

The decorator is used to automate the timing of a function and we do not have to repeat the timing logic over and over.

~~~python
import time

def timer(func):
	'''A decorator that prints how long a function took to run.

		Args:
			func (callable): The function being decorated.
	
		Returns:
			callable: The decorated function.
	'''
	
	def wrapper(*args, **kwargs):
		t_start = time.time()
		
		# things are happening here
		result = func(*args, **kwargs)
		
		duration = time.time() - t_start
		print('{} took {} seconds'.format(func.__name__, duration))
		
		return result	
	
	return wrapper
	
# Make use of the decorator with a function we are evaluating
@timer
def slow_function(n)
	# things are happening here
	time.sleep(n)

slow_function(10)
~~~
> slow_function took 10 seconds


# Examples, slow and fast.

## Combining items of two lists (loop vs zip)

~~~python
%%timeit
combined = []
for i, name in enumerate(nameList):
    combined.append((name, HTList[i]))
~~~
>17.8 ms ± 1.07 ms per loop (mean ± std. dev. of 7 runs, 100 loops each)

~~~python
%%timeit
combined_zip = zip(nameList, HTList)
~~~
>194 ns ± 1.06 ns per loop (mean ± std. dev. of 7 runs, 10000000 loops each)

Summary: The zip function is multiple magnitudes faster than the loop.


## Counting items on a list (loop vs Counter function)

The Counter function is part of the 'collections' package.

~~~python
%%timeit
height_counts = {}
for height in HTList:
    if height not in height_counts:
        height_counts[height] = 1
    else:
        height_counts[height] += 1
~~~
>12.4 ms ± 382 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)

~~~python
%%timeit
height_counts = Counter(HTList)
~~~
>4.96 ms ± 26.1 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)

Summary: Counter takes only about a third of  the loop.


## Number of combinations on a list (nested loop vs Combinations function)

~~~python
%%timeit
for x in nameList[:100]:
    for y in nameList[:100]:
        if x == y:
            continue
        if ((x,y) not in pairs) & ((y,x) not in pairs):
            pairs.append((x,y))
~~~
>1.98 s ± 23.3 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)

~~~python
%%timeit
combinations(nameList[:100],2)
~~~
>724 ns ± 6.85 ns per loop (mean ± std. dev. of 7 runs, 1000000 loops each)

Summary: The difference here is most staggering: almost two seconds for the nested loops and less than one millisecond for the function.


## Replace loops with built-in functions (zip, map)

~~~python
%%timeit
loop_output = []
for name,weight in zip(nameList, WTList):
    if weight < 100:
        name_length = len(name)
        tuple = (name, name_length)
        loop_output.append(tuple)
~~~
>11.7 ms ± 128 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)

~~~python
%%timeit
filtered_name_list = [name for name,weight in zip(nameList, WTList) if weight > 100]
name_lengths_map = map(len, filtered_name_list)
output = [*zip(filtered_name_list, name_lengths_map)]
~~~
>8.95 ms ± 280 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
