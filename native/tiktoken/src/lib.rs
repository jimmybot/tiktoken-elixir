use std::collections::HashSet;
use std::vec::Vec;

use tiktoken_rs::{
    cl100k_base_singleton, o200k_base_singleton, o200k_harmony_singleton, p50k_base_singleton,
    p50k_edit_singleton, r50k_base_singleton,
};

#[rustler::nif(schedule = "DirtyCpu")]
fn encoding_for_model(model: &str) -> Option<&str> {
    match tiktoken_rs::tokenizer::get_tokenizer(model) {
        Some(tiktoken_rs::tokenizer::Tokenizer::O200kHarmony) => Some("o200k_harmony"),
        Some(tiktoken_rs::tokenizer::Tokenizer::O200kBase) => Some("o200k_base"),
        Some(tiktoken_rs::tokenizer::Tokenizer::Cl100kBase) => Some("cl100k_base"),
        Some(tiktoken_rs::tokenizer::Tokenizer::P50kBase) => Some("p50k_base"),
        Some(tiktoken_rs::tokenizer::Tokenizer::R50kBase) => Some("r50k_base"),
        Some(tiktoken_rs::tokenizer::Tokenizer::P50kEdit) => Some("p50k_edit"),
        _ => None,
    }
}

// p50k

#[rustler::nif(schedule = "DirtyCpu")]
fn p50k_encode_ordinary(text: &str) -> Result<Vec<u32>, String> {
    Ok(p50k_base_singleton().encode_ordinary(text))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn p50k_encode(text: &str, allowed_special: Vec<&str>) -> Result<Vec<u32>, String> {
    let set = HashSet::from_iter(allowed_special.iter().cloned());
    p50k_base_singleton()
        .encode(text, &set)
        .map(|(ids, _)| ids)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn p50k_encode_with_special_tokens(text: &str) -> Result<Vec<u32>, String> {
    Ok(p50k_base_singleton().encode_with_special_tokens(text))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn p50k_decode(ids: Vec<u32>) -> Result<String, String> {
    p50k_base_singleton()
        .decode(&ids)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn p50k_count_tokens(text: &str, allowed_special: Vec<&str>) -> Result<usize, String> {
    let set: HashSet<&str> = allowed_special.into_iter().collect();
    p50k_base_singleton()
        .count(text, &set)
        .map_err(|e| e.to_string())
}

// p50k edit

#[rustler::nif(schedule = "DirtyCpu")]
fn p50k_edit_encode_ordinary(text: &str) -> Result<Vec<u32>, String> {
    Ok(p50k_edit_singleton().encode_ordinary(text))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn p50k_edit_encode(text: &str, allowed_special: Vec<&str>) -> Result<Vec<u32>, String> {
    let set = HashSet::from_iter(allowed_special.iter().cloned());
    p50k_edit_singleton()
        .encode(text, &set)
        .map(|(ids, _)| ids)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn p50k_edit_encode_with_special_tokens(text: &str) -> Result<Vec<u32>, String> {
    Ok(p50k_edit_singleton().encode_with_special_tokens(text))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn p50k_edit_decode(ids: Vec<u32>) -> Result<String, String> {
    p50k_edit_singleton()
        .decode(&ids)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn p50k_edit_count_tokens(text: &str, allowed_special: Vec<&str>) -> Result<usize, String> {
    let set: HashSet<&str> = allowed_special.into_iter().collect();
    p50k_edit_singleton()
        .count(text, &set)
        .map_err(|e| e.to_string())
}

// r50k

#[rustler::nif(schedule = "DirtyCpu")]
fn r50k_encode_ordinary(text: &str) -> Result<Vec<u32>, String> {
    Ok(r50k_base_singleton().encode_ordinary(text))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn r50k_encode(text: &str, allowed_special: Vec<&str>) -> Result<Vec<u32>, String> {
    let set = HashSet::from_iter(allowed_special.iter().cloned());
    r50k_base_singleton()
        .encode(text, &set)
        .map(|(ids, _)| ids)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn r50k_encode_with_special_tokens(text: &str) -> Result<Vec<u32>, String> {
    Ok(r50k_base_singleton().encode_with_special_tokens(text))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn r50k_decode(ids: Vec<u32>) -> Result<String, String> {
    r50k_base_singleton()
        .decode(&ids)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn r50k_count_tokens(text: &str, allowed_special: Vec<&str>) -> Result<usize, String> {
    let set: HashSet<&str> = allowed_special.into_iter().collect();
    r50k_base_singleton()
        .count(text, &set)
        .map_err(|e| e.to_string())
}

// cl100k

#[rustler::nif(schedule = "DirtyCpu")]
fn cl100k_encode_ordinary(text: &str) -> Result<Vec<u32>, String> {
    Ok(cl100k_base_singleton().encode_ordinary(text))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn cl100k_encode(text: &str, allowed_special: Vec<&str>) -> Result<Vec<u32>, String> {
    let set = HashSet::from_iter(allowed_special.iter().cloned());
    cl100k_base_singleton()
        .encode(text, &set)
        .map(|(ids, _)| ids)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn cl100k_encode_with_special_tokens(text: &str) -> Result<Vec<u32>, String> {
    Ok(cl100k_base_singleton().encode_with_special_tokens(text))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn cl100k_decode(ids: Vec<u32>) -> Result<String, String> {
    cl100k_base_singleton()
        .decode(&ids)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn cl100k_count_tokens(text: &str, allowed_special: Vec<&str>) -> Result<usize, String> {
    let set: HashSet<&str> = allowed_special.into_iter().collect();
    cl100k_base_singleton()
        .count(text, &set)
        .map_err(|e| e.to_string())
}

// o200k

#[rustler::nif(schedule = "DirtyCpu")]
fn o200k_encode_ordinary(text: &str) -> Result<Vec<u32>, String> {
    Ok(o200k_base_singleton().encode_ordinary(text))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn o200k_encode(text: &str, allowed_special: Vec<&str>) -> Result<Vec<u32>, String> {
    let set = HashSet::from_iter(allowed_special.iter().cloned());
    o200k_base_singleton()
        .encode(text, &set)
        .map(|(ids, _)| ids)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn o200k_encode_with_special_tokens(text: &str) -> Result<Vec<u32>, String> {
    Ok(o200k_base_singleton().encode_with_special_tokens(text))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn o200k_decode(ids: Vec<u32>) -> Result<String, String> {
    o200k_base_singleton()
        .decode(&ids)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn o200k_count_tokens(text: &str, allowed_special: Vec<&str>) -> Result<usize, String> {
    let set: HashSet<&str> = allowed_special.into_iter().collect();
    o200k_base_singleton()
        .count(text, &set)
        .map_err(|e| e.to_string())
}

// o200k harmony

#[rustler::nif(schedule = "DirtyCpu")]
fn o200k_harmony_encode_ordinary(text: &str) -> Result<Vec<u32>, String> {
    Ok(o200k_harmony_singleton().encode_ordinary(text))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn o200k_harmony_encode(text: &str, allowed_special: Vec<&str>) -> Result<Vec<u32>, String> {
    let set = HashSet::from_iter(allowed_special.iter().cloned());
    o200k_harmony_singleton()
        .encode(text, &set)
        .map(|(ids, _)| ids)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn o200k_harmony_encode_with_special_tokens(text: &str) -> Result<Vec<u32>, String> {
    Ok(o200k_harmony_singleton().encode_with_special_tokens(text))
}

#[rustler::nif(schedule = "DirtyCpu")]
fn o200k_harmony_decode(ids: Vec<u32>) -> Result<String, String> {
    o200k_harmony_singleton()
        .decode(&ids)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn o200k_harmony_count_tokens(text: &str, allowed_special: Vec<&str>) -> Result<usize, String> {
    let set: HashSet<&str> = allowed_special.into_iter().collect();
    o200k_harmony_singleton()
        .count(text, &set)
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn context_size_for_model(model: &str) -> Option<usize> {
    tiktoken_rs::model::get_context_size(model)
}

rustler::init!("Elixir.Tiktoken.Native");
