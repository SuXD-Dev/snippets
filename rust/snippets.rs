//! Useful Rust code snippets.

use std::collections::{HashMap, HashSet};
use std::fs;
use std::io::{self, BufRead, Write};

/// Read entire file to string.
pub fn read_file(path: &str) -> Result<String, io::Error> {
    fs::read_to_string(path)
}

/// Read file lines.
pub fn read_lines(path: &str) -> Result<Vec<String>, io::Error> {
    let file = fs::File::open(path)?;
    io::BufReader::new(file).lines().collect()
}

/// Write string to file.
pub fn write_file(path: &str, content: &str) -> Result<(), io::Error> {
    fs::write(path, content)
}

/// Count word frequency in text.
pub fn word_count(text: &str) -> HashMap<String, usize> {
    let mut counts = HashMap::new();
    for word in text.split_whitespace() {
        let clean: String = word.chars()
            .filter(|c| c.is_alphanumeric())
            .flat_map(|c| c.to_lowercase())
            .collect();
        if !clean.is_empty() {
            *counts.entry(clean).or_insert(0) += 1;
        }
    }
    counts
}

/// Remove duplicates while preserving order.
pub fn dedup<T: Clone + Eq + std::hash::Hash>(items: &[T]) -> Vec<T> {
    let mut seen = HashSet::new();
    items.iter()
        .filter(|item| seen.insert(*item))
        .cloned()
        .collect()
}

/// Chunk a slice into smaller slices.
pub fn chunk<T>(data: &[T], size: usize) -> Vec<&[T]> {
    data.chunks(size).collect()
}

/// Simple timer utility.
pub struct Timer {
    start: std::time::Instant,
}

impl Timer {
    pub fn new() -> Self {
        Timer { start: std::time::Instant::now() }
    }

    pub fn elapsed_ms(&self) -> u128 {
        self.start.elapsed().as_millis()
    }

    pub fn elapsed(&self) -> String {
        let ms = self.elapsed_ms();
        if ms < 1000 {
            format!("{}ms", ms)
        } else {
            format!("{:.2}s", ms as f64 / 1000.0)
        }
    }
}

fn main() {
    let text = "hello world hello rust world world";
    let counts = word_count(text);
    println!("Word counts: {:?}", counts);

    let nums = vec![1, 2, 2, 3, 3, 3, 4];
    println!("Dedup: {:?}", dedup(&nums));
    println!("Chunks: {:?}", chunk(&nums, 2));

    let t = Timer::new();
    std::thread::sleep(std::time::Duration::from_millis(100));
    println!("Elapsed: {}", t.elapsed());
}
