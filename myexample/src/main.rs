use icrate::Foundation::{ns_string, NSCopying, NSArray};
fn main() {
    let string = ns_string!("world");
    println!("hello {string}");
    
    let array = NSArray::from_id_slice(&[string.copy()]);
    println!("{array:?}");
}

