#[macro_use]
extern crate lazy_static;
#[macro_use]
extern crate rustler;

extern crate woothee;

use rustler::types::tuple::make_tuple;
use rustler::Atom;
use rustler::{Binary, Encoder, Env, Error, OwnedBinary, Term};
use std::fmt;
use std::fmt::Debug;
use std::io::Write;
use std::str;
use woothee::parser::*;

mod atoms {
    rustler_atoms! {
        // Generic default value for unknown field
        atom other;

        // Browser types
        atom browser;
        atom full;
        atom os;
        // atom other;

        // (Device) Categories
        atom appliance;
        atom crawler;
        atom misc;
        atom mobilephone;
        atom pc;
        atom smartphone;
        // atom other;
    }
}

rustler::rustler_export_nifs! {
    "Elixir.Wootheex",
    [
        ("parse", 1, parse)
    ],
    None
}

lazy_static! {
    static ref PARSER: Parser = Parser::new();
}

// Proxy for rustler Error struct to get around known to be safe unwrap()
// of created subbinary (None only for wrong boundaries)
pub struct ErrorProxy(Error);
impl Debug for ErrorProxy {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        // Result<(), Error>;
        write!(f, "Rustler Error")
    }
}

fn parse<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    args[0]
        .into_binary()
        .and_then(|bin| match str::from_utf8(bin.as_slice()) {
            Ok(s) => Ok(s),
            Err(utf8err) => match utf8err.error_len() {
                None => Err(Error::Atom("ended_unexpectedly")),
                Some(_len) => Err(Error::BadArg),
            },
        })
        .and_then(|s| match PARSER.parse(s) {
            None => Ok(atoms::other().encode(env)),
            Some(res) => parse_result_to_tuple(env, &res),
        })
}

fn is_not_unknown(result: &str) -> bool {
    result != "UNKNOWN"
}

fn browser_type_to_atom(s: &str) -> Atom {
    match s {
        "browser" => atoms::browser(),
        "full" => atoms::full(),
        "os" => atoms::os(),
        _ => atoms::other(),
    }
}

fn category_to_atom(s: &str) -> Atom {
    match s {
        "appliance" => atoms::appliance(),
        "crawler" => atoms::crawler(),
        "misc" => atoms::misc(),
        "mobilephone" => atoms::mobilephone(),
        "pc" => atoms::pc(),
        "smartphone" => atoms::smartphone(),
        _ => atoms::other(),
    }
}

fn parse_result_to_tuple<'a>(
    env: Env<'a>,
    parse_result: &WootheeResult,
) -> Result<Term<'a>, Error> {
    let WootheeResult {
        category,
        browser_type,
        name: ns,
        os,
        os_version: ovs_cowp,
        version: btvs,
        vendor: vs,
    } = parse_result;
    // Probably TODO:
    // Unnecessary copy here
    // Possibly fork woothee_rust and change it to write to binaries directly

    let mut bin_slice: &mut [u8];
    let strs: [(&str, bool); 5];

    let cat_term = category_to_atom(category).to_term(env);
    let type_term = browser_type_to_atom(browser_type).to_term(env);

    let ovs = &ovs_cowp;
    strs = [
        (ns, is_not_unknown(ns)),
        (btvs, is_not_unknown(btvs)),
        (os, is_not_unknown(os)),
        (ovs, is_not_unknown(ovs)),
        (vs, is_not_unknown(vs)),
    ];
    let total_size = strs
        .iter()
        .fold(0, |acc, (s, ok)| if *ok { acc + s.len() } else { acc });

    match OwnedBinary::new(total_size) {
        None => Err(Error::Atom("alloc_failed")),
        Some(mut owned_bin) => {
            bin_slice = owned_bin.as_mut_slice();

            let mut offset = 0;

            for (s, ok) in strs.iter() {
                if *ok {
                    bin_slice.write_all(s.as_bytes()).unwrap();
                }
            }

            let bin = Binary::from_owned(owned_bin, env);

            let mut bin_vec: Vec<Term> = Vec::with_capacity(7);
            let bvr = &mut bin_vec;

            let mut add_str_as_subbinary = |p: &mut Vec<Term<'a>>, (s, ok): (&str, bool)| {
                let term = {
                    if ok {
                        let len = s.len();
                        let subbin = bin
                            .make_subbinary(offset, len)
                            .map_err(ErrorProxy)
                            .unwrap()
                            .to_term(env);
                        offset += len;
                        subbin
                    } else {
                        atoms::other().to_term(env)
                    }
                };
                p.push(term);
            };

            bvr.push(cat_term);
            add_str_as_subbinary(bvr, strs[0]);
            bvr.push(type_term);

            for v in strs[1..].iter() {
                add_str_as_subbinary(bvr, *v)
            }

            Ok(make_tuple(env, bin_vec.as_slice()).encode(env))
        }
    }
}
