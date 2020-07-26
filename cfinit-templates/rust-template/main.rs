use std::fmt::Debug;
use std::str::FromStr;

pub struct TokenReader {
    reader: std::io::Stdin,
    tokens: Vec<String>,
    index: usize,
}

impl TokenReader {
    pub fn new() -> Self {
        Self {
            reader: std::io::stdin(),
            tokens: Vec::new(),
            index: 0,
        }
    }

    pub fn next<T>(&mut self) -> T
    where
        T: FromStr,
        T::Err: Debug,
    {
        if self.index >= self.tokens.len() {
            self.load_next_line();
        }
        self.index += 1;
        self.tokens[self.index - 1].parse().unwrap()
    }

    pub fn vector<T>(&mut self) -> Vec<T>
    where
        T: FromStr,
        T::Err: Debug,
    {
        if self.index >= self.tokens.len() {
            self.load_next_line();
        }
        self.index = self.tokens.len();
        self.tokens.iter().map(|tok| tok.parse().unwrap()).collect()
    }

    pub fn load_next_line(&mut self) {
        let mut line = String::new();
        self.reader.read_line(&mut line).unwrap();

        self.tokens = line
            .split_whitespace()
            .map(String::from)
            .collect();
        self.index = 0;
    }
}

fn main() {
    let mut reader = TokenReader::new();
}
