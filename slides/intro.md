## Rust Introduction

---

### Rust is a system programming language pursuing the trifecta

- Safe
- Concurrent
- Fast


---

## Safe

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

## Modern Tooling

* Rustup
* Cargo
* Integrated Test
