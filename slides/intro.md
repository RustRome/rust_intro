# Elixir NIFs with Mozilla Rust

---

## Greetings

---

## Have we ever meet? 
Have you ever worked with Mozilla Rust? 
And Elixir? 

---

## Why Elixir? 
* Powerful dynamic language
* Fast learning curve
* And...

---

## Because is designed for: 
- Easy **concurrency**
- **Fault tolerance**
- To be **maintainable**
- To be **scalable**
- To help you build **distributed applications**

---

## HOW?! 
Elixir runs on the Beam virtual machine

---

## The Beam 
* Light-weight process
* No memory sharing
* Code hot-swap out of the box
* Battle tested
* OTP: a powerful concurrency library 

---

## The Supervisor tree
<img src="../img/supervisor_tree.png"> 

---

## Fault Tolerance
<img src="../img/zombies.png"/>

---

## Genserver 
Genserver is abstraction around a process.
<pre>
<code data-trim="hljs elixir" class="lang-elixir">
defmodule TodoList do
  use GenServer
end
</code>
</pre>

---

<pre>
<code data-trim="hljs elixir" class="lang-elixir">
defmodule Todolist do
  use GenServer
  
  def start(list) do
    GenServer.start_link(__MODULE__, list, name: __MODULE__)
  end
 
  def list_tasks() do
    GenServer.call(__MODULE__, {:list})
  end
  
  def add_task(task) do
    GenServer.cast(__MODULE__, {:add, task})
  end
  
  def handle_cast({:add, task}, list) do
    {:noreply, [task | list]}
  end
  
  def handle_call({:list}, _from, list) do
    {:reply, list, list}
  end
end
</code>
</pre>

---

## What the Beam cannot do for you? 
- Specific hardware access
- Blowing fast sequential computation

---


## NIFs
NIFs stands for Native Implemented Functions.  
These are programs mostly written in C we can call from Beam.  
Once called, a NIF takes the full control of computation,  
run with speed of light and can do anything as native code can.  
Sounds great but...

---

## How to crash the world most stable virtual machine 

* Fill the *atoms* table (1 million)
* Overflow the binary space
* Process heap failures:
  + Infinite recursion that spawns infinite process
  + Super very long message queues
  + A tons of data
* And of course... __errors inside NIFs__


---

## So NIFs as only for superheroes?

---

## Why Mozilla Rust? 

---

### Rust is a system programming language pursuing the trifecta

- Safe
- Concurrent
- Fast


---

## Safety

* Memory Safe
* No Illegal memory access
* Automatic deallocation

---

## Concurrent

* Compile time errors for concurrent access to data
* Prevent data races
* "Fearless concurrency"

---

## Fast

* Safety without runtime costs
* LLVM optimization
* Zero cost abstraction

---

## Basic Syntax

---

### Variables

<pre>
<code data-trim="hljs rust" class="lang-rust">
    let x = 5;
</code></pre>

<p>Variable are immutable by default</p>
<pre>
<code data-trim="hljs rust" class="lang-rust">
    let x = 5;
    x +=1;
</code></pre>

<pre>
 <code data-trim="hljs">
    error[E0384]: cannot assign twice to immutable variable `x`
 --> src/main.rs:7:4
  |
6 |    let x = 5;
  |        - first assignment to `x`
7 |    x +=1;
  |    ^^^^^ cannot assign twice to immutable variable
 </code>
</pre>

<p>mut keyword for mutability</p>
<pre>
<code data-trim="hljs rust" class="lang-rust">
    let mut x = 5;
    x +=1;
</code></pre>

---

### Basic Types

Rust is statically typed, but infers types for you in local context. You can write them out if you'd like:

<pre>
<code data-trim="hljs rust" class="lang-rust">
    let x = 5;
    let x : i32 = 5;
</code></pre>
Primitive types:

* Booleans
* Integers
* Floating point numbers
* Tuples
* Arrays
* References
* Slices
* char
* &str

---

### Functions



<pre>
<code data-trim="hljs rust" class="lang-rust">
    fn add(x: i32,y: i32) -> i32 {
        x + y
    }
</code></pre>

---

### if 

<pre>
<code data-trim="hljs rust" class="lang-rust">
    let value = 2;
    if value % 2 == 0 {
        // ...
    } else if value == 5 {
        // ...
    } else { /* ... */ }
</code></pre>

---

### for and while loops

<pre>
<code data-trim="hljs rust" class="lang-rust">
    /// loop
    loop {
        println!("again!");
    }
    /// for
    for i in 0..5 {
        println!("{}", i);
    }
    /// while
    let mut number = 3;
    while number != 0 {
        println!("{}!", number);
        number = number - 1;
    }

</code></pre>
    

---

### Structs
<pre>
<code data-trim="hljs rust" class="lang-rust">
struct Rectangle {
    width: u32,
    height: u32,
}
let rect = Rectangle { 
    width: 30, 
    height: 50 
};
</code></pre>


---

### Methods

<pre>
<code data-trim="hljs rust" class="lang-rust">
struct Rectangle {
    width: u32,
    height: u32,
}
impl Rectangle {
    pub fn area(&self) -> i32 {
        self.width * self.height
    }
}
let rect = Rectangle { 
    width: 30, 
    height: 50 
};

println!("Area {}",rect.area());

</code></pre>

---

### Enums

<pre>
<code data-trim="hljs rust" class="lang-rust">
type Explanation = String;

enum Choice {
    Yes,
    No,
    Maybe(Explanation),
}
let choice = Choice::Yes;
</code></pre>


---

### Match

<pre>
<code data-trim="hljs rust" class="lang-rust">
type Explanation = String;

enum Choice {
    Yes,
    No,
    Maybe(Explanation),
}
let choice = Choice::Yes;

match choice  {
    Choice::Yes => println!("{}","Yes"),
    Choice::No => println!("{}","No"),
    Choice::Maybe(r) => println!("Maybe reason : {}",r),
}
</code></pre>

---

### The Rust Way (Key Concepts)

* Ownership
* Borrowing
* Lifetime

---

## Ownership

- Each value in Rust has a variable that’s called its owner.
- There can only be one owner at a time.
- When the owner goes out of scope, the value will be dropped.
- Ownership can be passed on
- The owner can mutate the owned data

---

### Ownership Example

---

## Borrowing

- Expressed with &
- Immutable/ Mutable references
- Mutable references are exclusive.

---

## Lifetime

---

## Other Key concepts

* Generics
* Traits (Zero cost abstraction)
* No Exception (Result)
* No Null (Option)

---

## Why together? 
- 3D rendering
- Fast decoding/encoding
- GPU computation
- IOT
- Specific hardware access

---

## A little NIF 
