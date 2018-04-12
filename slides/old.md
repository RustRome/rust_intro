
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