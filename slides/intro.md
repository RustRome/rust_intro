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

## A simple supervisor
<pre>
<code data-trim="hljs elixir" class="lang-elixir">
defmodule SupervisorStore do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      worker(Archive, [])
    ]

    supervise(children, [strategy: :one_for_one])
  end
end
</code>
</pre>

---

## Fault Tolerance
<img src="../img/zombies.png"/>

---

## Genserver 
Genserver is abstraction around a process.
<pre>
<code data-trim="hljs elixir" class="lang-elixir">
defmodule Archive do
  use GenServer
  # here we declare a public api to send command to the store 
  # and its logic to store, delete, store with ttl, retrieve the whole archive
end
</code>
</pre>

---

## Our service (process) api
<pre>
<code data-trim="hljs elixir" class="lang-elixir">
  ### Client API
  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def add_item(item) do
    GenServer.cast(__MODULE__, {:add, item})
  end

  def add_item(item, ttl) do
    GenServer.cast(__MODULE__, {:add, item, ttl})
  end

  def del_item(key) do
    send __MODULE__, {:del, key}
  end

  def get_list do
    GenServer.call(__MODULE__, :list)
  end

  # Look this! This will crash the process. Try it! 
  def this_will_crash do
    send __MODULE__, {:add, 1}
  end
</code>
</pre>

---

## The internal callbacks of the GenServer
<pre>
<code data-trim="hljs elixir" class="lang-elixir">
  def init(state), do: {:ok, state}

  def handle_cast({:add, item}, state) do
    {:noreply, internal_add_item(item, state)}
  end

  def handle_info({:del, key}, state) do
    {:noreply, Map.delete(state, key)}
  end

  def handle_cast({:add, item, ttl}, state) do
    key = elem(Enum.at(item, 0), 0)
    Process.send_after(__MODULE__, {:del, key}, ttl)
    {:noreply, internal_add_item(item, state)}
  end

  defp internal_add_item(item, state) do
    Map.merge(item, state)
  end

  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end
</code>
</pre>

---

## Demo time

Load the Elixir repl  
```bash
iex -s MIX
```

Run our little demo  
```
Demo.start
```

Let's play with our key-value store  
```
Archive.add_item(%{test: "valore di test"})
Archive.get_list
...
```

Let's try to crash it. Supervisor will raise it up again...
```
Archive.this_will_crash
```

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

## What Safety means?

<pre>
<code data-trim="hljs cpp" class="lang-cpp">
// C++
void example() {
  vector&ltstring&gt vector;
  ...
  auto& elem = vector[0];
  ...
  vector.push_back(some_string);
  cout << elem;
}
</code>
</pre>

<img src="../img/safety.png"> 


---

## What Safety means?

<p>
Problem with safety happens when we have a resource that at the same time:
</p>

- has alias: more references to the resource
- is mutable: someone can modify the resource

<p>
That is (almost) the definition of data race.
</p>

<p>
    alias + mutable = 💀
<p/>

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
* No GC

---

### The Rust Way (Key Concepts)

* Ownership
* Borrowing
* Lifetimes

---

## Ownership

- Each resource in Rust has one owner at time.
- When the owner goes out of scope, the resource will be dropped.
- Ownership can be transferred
- The owner can mutate the owned data

---

### Ownership Example


<pre>
<code data-trim="hljs rust" class="lang-rust">

fn main() {
    let mut vec = Vec::new();
    vec.push(1);
    take(vec);
}

fn take(vec : Vec&lti32&gt) {
    println!("{:?}", vec);
}
</code>
</pre>


---


### Ownership Example


<pre>
<code data-trim="hljs rust" class="lang-rust rust-interactive">

fn main() {
    let mut vec = Vec::new();
    vec.push(1);
    take(vec);
    take(vec);
}

fn take(vec : Vec&lti32&gt) {
    println!("{:?}", vec);
}
</code>
</pre>


---

## Borrowing

- Express shared reference to values
- Immutable/ Mutable references
- Mutable references are exclusive.

---

## Borrowing with &T 


<pre>
<code data-trim="hljs rust" class="lang-rust rust-interactive">

fn main() {
    let mut vec = Vec::new();
    vec.push(1);
    print(&vec);
    print(&vec);
}

fn print(vec : &Vec&lti32&gt) {
    println!("{:?}", vec);
}
</code>
</pre>

---


## Borrowing WITH  &mut T 


<pre>
<code data-trim="hljs rust" class="lang-rust rust-interactive">

fn main() {
    let mut vec = Vec::new();
    vec.push(1);
    print(&vec);
    push_two(&mut vec);
    print(&vec);
}

fn print(vec : &Vec&lti32&gt) {
    println!("{:?}", vec);
}
fn push_two(vec : &mut Vec&lti32&gt) {
    vec.push(2);
}
</code>
</pre>

---

## Safety at compile time


<pre>
<code data-trim="hljs rust" class="lang-rust rust-interactive">

fn main() {
    let mut vec = Vec::new();
    vec.push(1);
    let _elem = vec.get(0);
    push_two(&mut vec);
}

fn push_two(vec : &mut Vec&lti32&gt) {
    vec.push(2);
}
</code>
</pre>

---

## Lifetimes


- Lifetimes describe the time that values remain in memory
- A variable's lifetime begins when it is created and ends when it is destroyed
- In simplest cases, compiler recognize eventual problem (borrow checker) and refuse to compile.
- In more complex scenarios compiler needs an hint.


---


## Other Key concepts

* No Exception 
* No Null
* Structs
* Enum on steroids
* Pattern matching
* Generics
* Traits (Zero cost abstraction)




---

## Result type

<p>Exceptions do not exist in Rust </p>

<pre>
<code data-trim="hljs rust" class="lang-rust">


enum Result&ltT, E&gt {
    Ok(T),
    Err(E),
}

fn main() {
    let x : Result&lti32,&str&gt = Ok(7);
    let y : Result&lti32,&str&gt = Err("Too bad");

    match x {
        Ok(n) => println!("{}",n),
        Err(e) => println!("{}",e)
    }
}



</code>
</pre>


---

## Option type

<p>Null does not exist in Rust</p>
<pre>
<code data-trim="hljs rust" class="lang-rust">

enum Option&ltT&gt {
	None,
	Some(T),
}

fn main() {
    let x = Some(7);
    let y : Option&lti32&gt = None;


    match x {
        Some(n) => println!("{}",n),
        None => println!("Not found")
    }
}



</code>
</pre>


---


## Why together? 
- 3D rendering
- Fast decoding/encoding
- GPU computation
- IOT
- Specific hardware access

---

## A Rusty NIF 


---

## Rustler

- A library for writing NIFs in Rust
- Handle encoding and decoding of Erlang terms (Interoperability)
- It should never be able to crash the BEAM (safety)
- Resource objects
- Easy to use

<p>https://github.com/hansihe/rustler</p>

---

## Getting Started
</br>
</br>
### $ mix new image

---

### mix.exs


<pre>
<code data-trim="hljs elixir" class="lang-elixir">
  defp deps do
    [
      {:rustler, "~> 0.16.0"}
    ]
  end
</code>
</pre>

---



<pre>
<code data-trim="hljs bash" class="lang-bash">
$ mix rustler.new
==> rustler
Compiling 2 files (.erl)
Compiling 6 files (.ex)
Generated rustler app
==> image
This is the name of the Elixir module the NIF module will be registered to.
Module name > Image
This is the name used for the generated Rust crate. The default is most likely fine.
Library name (image) > img
* creating native/img/README.md
* creating native/img/Cargo.toml
* creating native/img/src/lib.rs
Ready to go! 

</code>
</pre>

---

## Rustler compiler

<pre>
<code data-trim="hljs elixir" class="lang-elixir">

defmodule Image.MixProject do
  use Mix.Project

  def project do
    [
      app: :image,
      version: "0.1.0",
      elixir: "~> 1.6",
      compilers: [:rustler] ++ Mix.compilers,
      start_permanent: Mix.env() == :prod,
      rustler_crates: rustler_crates(),
      deps: deps()
    ]
  end

  ...
end

</code>
</pre>

---

## Crate Config

<pre>
<code data-trim="hljs elixir" class="lang-elixir">

  defp rustler_crates do
    [img: [
      path: "native/img",
      mode: rustc_mode(Mix.env)
    ]]
  end
  defp rustc_mode(:prod), do: :release
  defp rustc_mode(_), do: :debug

</code>
</pre>  

---

## Module definition


<pre>
<code data-trim="hljs elixir" class="lang-elixir">

defmodule Image do
  use Rustler, otp_app: :image, crate: "img"

  def add(_x,_y), do: err()

  def flip(_source,_dest), do: err()

  defp err() do
    throw(NifNotLoadedError)
  end
end


</code>
</pre> 

---

## lib.rs


<pre>
<code data-trim="hljs rust" class="lang-rust long">
#[macro_use] extern crate rustler;
#[macro_use] extern crate rustler_codegen;
#[macro_use] extern crate lazy_static;
extern crate image;
use std::fs::File;
use std::path::Path;
use rustler::{NifEnv, NifTerm, NifResult, NifEncoder,NifError};
mod atoms {
    rustler_atoms! {
        atom ok;
    }
}
rustler_export_nifs! {
    "Elixir.Image",
    [("add", 2, add),("flip", 2, flip)],
    None
}
fn add&lt'a&gt(env: NifEnv&lt'a&gt, args: &[NifTerm&lt'a&gt]) -> NifResult&ltNifTerm<'a&gt&gt {
    let num1: i64 = args[0].decode()?;
    let num2: i64 = args[1].decode()?;

    Ok((atoms::ok(), num1 + num2).encode(env))
}
...

</code>
</pre> 


---

## lib.rs


<pre>
<code data-trim="hljs rust" class="lang-rust long">
...

fn flip&lt'a&gt(env: NifEnv&lt'a&gt, args: &[NifTerm&lt'a&gt]) -> NifResult&ltNifTerm&lt'a&gt&gt {
    let input: String = args[0].decode()?;
    let output: String = args[1].decode()?;

    let img =
        image::open(&Path::new(&input)).map_err(|_e| NifError::Atom("Cannot open input file"))?;

    let filtered = img.fliph();
    let mut out =
        File::create(&Path::new(&output)).map_err(|_e| NifError::Atom("Cannot create a new file"))?;

    let _ = filtered
        .save(&mut out, image::PNG)
        .map_err(|_e| NifError::Atom("Cannot save new file in PNG"))?;
    Ok((atoms::ok(), output).encode(env))
}

</code>
</pre> 

---

## Projects with Rustler

- Html5ever (Servo HTML5 parser)
- Juicy (JSON parser)
- Rox (RocksDB bindings)
- Flower (Bloom filter)



---

## Thanks
