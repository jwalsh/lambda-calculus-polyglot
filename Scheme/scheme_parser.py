import re
from collections import defaultdict
from typing import Dict, Set, List, Tuple
import click
import os

# WIP: Rules for the linting of a Scheme file
RULES = {'only-allowed', 'single-arity', 'no-comments'}

ALLOWED_PRIMITIVES = {'define', 'lambda', 'quote', 'error'}

SCHEME_PRIMITIVES = {
    # 11.2 Definitions
    'define', 'define-syntax', 'let-syntax', 'letrec-syntax', 'syntax-rules',

    # 11.4 Expressions
    'quote', 'lambda', 'if', 'set!', 'begin', 'let', 'let*', 'letrec', 'letrec*',
    'and', 'or', 'do', 'let-values', 'let*-values', 'case', 'cond', 'quasiquote',
    'unquote', 'unquote-splicing', 'case-lambda',

    # 11.5 Macros
    'syntax-case', 'identifier-syntax',

    # 11.6 Library syntax
    'library', 'export', 'import', 'for', 'run', 'expand', 'meta', 'rename',
    'only', 'except', 'prefix',

    # 11.7 Program syntax
    'import',

    # 11.8 Arithmetic
    '+', '-', '*', '/', 'quotient', 'remainder', 'modulo', 'div', 'mod', 'div-and-mod',
    'div0', 'mod0', 'div0-and-mod0', 'numerator', 'denominator', 'floor', 'ceiling',
    'truncate', 'round', 'rationalize', 'real-part', 'imag-part', 'make-rectangular',
    'make-polar', 'magnitude', 'angle', 'exact', 'inexact', 'exact?', 'inexact?',
    'finite?', 'infinite?', 'nan?', 'max', 'min', 'abs', 'exp', 'log', 'sin', 'cos',
    'tan', 'asin', 'acos', 'atan', 'sqrt', 'exact-integer-sqrt', 'expt', 'number?',
    'complex?', 'real?', 'rational?', 'integer?', 'zero?', 'positive?', 'negative?',
    'odd?', 'even?', '=', '<', '>', '<=', '>=',

    # 11.9 Booleans
    'not', 'boolean?', 'boolean=?',

    # 11.10 Pairs and lists
    'pair?', 'cons', 'car', 'cdr', 'caar', 'cadr', 'cdar', 'cddr', 'caaar', 'caadr',
    'cadar', 'caddr', 'cdaar', 'cdadr', 'cddar', 'cdddr', 'caaaar', 'caaadr', 'caadar',
    'caaddr', 'cadaar', 'cadadr', 'caddar', 'cadddr', 'cdaaar', 'cdaadr', 'cdadar',
    'cdaddr', 'cddaar', 'cddadr', 'cdddar', 'cddddr', 'null?', 'list?', 'list',
    'make-list', 'length', 'append', 'reverse', 'list-tail', 'list-ref', 'list-set!',
    'memq', 'memv', 'member', 'assq', 'assv', 'assoc', 'list-copy',

    # 11.11 Symbols
    'symbol?', 'symbol->string', 'string->symbol', 'symbol=?',

    # 11.12 Characters
    'char?', 'char->integer', 'integer->char', 'char=?', 'char<?', 'char>?', 'char<=?',
    'char>=?', 'char-ci=?', 'char-ci<?', 'char-ci>?', 'char-ci<=?', 'char-ci>=?',
    'char-alphabetic?', 'char-numeric?', 'char-whitespace?', 'char-upper-case?',
    'char-lower-case?', 'char-title-case?', 'char-general-category', 'char-upcase',
    'char-downcase', 'char-titlecase', 'char-foldcase',

    # 11.13 Strings
    'string?', 'make-string', 'string', 'string-length', 'string-ref', 'string-set!',
    'string=?', 'string-ci=?', 'string<?', 'string-ci<?', 'string>?', 'string-ci>?',
    'string<=?', 'string-ci<=?', 'string>=?', 'string-ci>=?', 'substring', 'string-append',
    'string->list', 'list->string', 'string-copy', 'string-copy!', 'string-fill!',
    'string-upcase', 'string-downcase', 'string-titlecase', 'string-foldcase',

    # 11.14 Vectors
    'vector?', 'make-vector', 'vector', 'vector-length', 'vector-ref', 'vector-set!',
    'vector->list', 'list->vector', 'vector->string', 'string->vector', 'vector-copy',
    'vector-copy!', 'vector-append', 'vector-fill!',

    # 11.15 Bytevectors
    'bytevector?', 'make-bytevector', 'bytevector', 'bytevector-length', 'bytevector-u8-ref',
    'bytevector-u8-set!', 'bytevector-copy', 'bytevector-copy!', 'bytevector-append',
    'utf8->string', 'string->utf8',

    # 11.16 Control features
    'procedure?', 'apply', 'map', 'string-map', 'vector-map', 'for-each', 'string-for-each',
    'vector-for-each', 'call-with-current-continuation', 'call/cc', 'values',
    'call-with-values', 'dynamic-wind',

    # 11.17 Exceptions
    'with-exception-handler', 'raise', 'raise-continuable', 'error', 'error-object?',
    'error-object-message', 'error-object-irritants', 'assert',

    # 11.18 Environments and evaluation
    'environment', 'scheme-report-environment', 'null-environment', 'interaction-environment', 'eval',

    # 11.19 Input and output
    'call-with-input-file', 'call-with-output-file', 'current-input-port', 'current-output-port',
    'current-error-port', 'with-input-from-file', 'with-output-to-file', 'open-input-file',
    'open-output-file', 'close-input-port', 'close-output-port', 'read-char', 'peek-char',
    'read', 'write-char', 'newline', 'display', 'write', 'read-line', 'write-string', 'port?',
    'input-port?', 'output-port?', 'textual-port?', 'binary-port?', 'port-open?',
    'input-port-open?', 'output-port-open?', 'close-port', 'call-with-port', 'open-file-input-port',
    'open-file-output-port', 'open-input-bytevector', 'open-output-bytevector', 'get-output-bytevector',
    'open-input-string', 'open-output-string', 'get-output-string', 'standard-input-port',
    'standard-output-port', 'standard-error-port', 'current-input-port', 'current-output-port',
    'current-error-port', 'eof-object', 'eof-object?', 'flush-output-port',
    
    # 11.20 System interface
    'load', 'file-exists?', 'delete-file', 'command-line', 'exit',

    # Additional syntactic keywords
    'else', '=>', 'unquote', 'unquote-splicing', '...', '_',

    # R6RS Standard Libraries
    'fixnum?', 'fixnum-width', 'least-fixnum', 'greatest-fixnum', 'fx=?', 'fx>?', 'fx<?', 'fx>=?', 'fx<=?',
    'fxzero?', 'fxpositive?', 'fxnegative?', 'fxodd?', 'fxeven?', 'fxmax', 'fxmin', 'fx+', 'fx*', 'fx-',
    'fxdiv', 'fxmod', 'fxdiv-and-mod', 'fxdiv0', 'fxmod0', 'fxdiv0-and-mod0', 'fx+/carry', 'fx-/carry',
    'fx*/carry', 'fxnot', 'fxand', 'fxior', 'fxxor', 'fxif', 'fxbit-count', 'fxlength', 'fxfirst-bit-set',
    'fxbit-set?', 'fxcopy-bit', 'fxbit-field', 'fxcopy-bit-field', 'fxarithmetic-shift',
    'fxarithmetic-shift-left', 'fxarithmetic-shift-right', 'fxrotate-bit-field', 'fxreverse-bit-field',
    'flonum?', 'real->flonum', 'fl=?', 'fl<?', 'fl>?', 'fl<=?', 'fl>=?', 'flinteger?', 'flzero?',
    'flpositive?', 'flnegative?', 'flodd?', 'fleven?', 'flfinite?', 'flinfinite?', 'flnan?', 'flmax',
    'flmin', 'fl+', 'fl*', 'fl-', 'fl/', 'flabs', 'fldiv', 'flmod', 'fldiv-and-mod', 'fldiv0', 'flmod0',
    'fldiv0-and-mod0', 'flnumerator', 'fldenominator', 'flfloor', 'flceiling', 'fltruncate', 'flround',
    'flexp', 'fllog', 'flsin', 'flcos', 'fltan', 'flasin', 'flacos', 'flatan', 'flsqrt', 'flexpt',
    'bitwise-not', 'bitwise-and', 'bitwise-ior', 'bitwise-xor', 'bitwise-if', 'bitwise-bit-count',
    'bitwise-length', 'bitwise-first-bit-set', 'bitwise-bit-set?', 'bitwise-copy-bit',
    'bitwise-bit-field', 'bitwise-copy-bit-field', 'bitwise-arithmetic-shift',
    'bitwise-arithmetic-shift-left', 'bitwise-arithmetic-shift-right', 'bitwise-rotate-bit-field',
    'bitwise-reverse-bit-field',
}

def tokenize(content: str) -> List[str]:
    """Tokenize the Scheme content."""
    return re.findall(r'\(|\)|[^\s()]+', content)

def parse(tokens: List[str]) -> List:
    """Parse the tokens into a nested list structure."""
    if len(tokens) == 0:
        raise SyntaxError("Unexpected EOF")
    
    token = tokens.pop(0)
    if token == '(':
        L = []
        while tokens[0] != ')':
            L.append(parse(tokens))
        tokens.pop(0)  # pop off ')'
        return L
    elif token == ')':
        raise SyntaxError("Unexpected ')'")
    else:
        return token

def analyze_expression(expr: List, defined_funcs: Set[str], lambda_params: Set[str], non_allowed_used: Dict[str, int]) -> None:
    """Analyze an expression and update the non_allowed_used dictionary."""
    if isinstance(expr, list) and len(expr) > 0:
        if expr[0] == 'define':
            defined_funcs.add(expr[1])
            if isinstance(expr[2], list) and expr[2][0] == 'lambda':
                lambda_params = set(expr[2][1])
                analyze_expression(expr[2][2], defined_funcs, lambda_params, non_allowed_used)
            else:
                analyze_expression(expr[2], defined_funcs, lambda_params, non_allowed_used)
        elif expr[0] == 'lambda':
            lambda_params = set(expr[1])
            analyze_expression(expr[2], defined_funcs, lambda_params, non_allowed_used)
        else:
            if isinstance(expr[0], str):
                if expr[0] not in ALLOWED_PRIMITIVES:
                    if expr[0] in SCHEME_PRIMITIVES or expr[0] not in defined_funcs and expr[0] not in lambda_params:
                        non_allowed_used[expr[0]] += 1
            for sub_expr in expr[1:]:
                analyze_expression(sub_expr, defined_funcs, lambda_params, non_allowed_used)
    elif isinstance(expr, str) and expr not in ALLOWED_PRIMITIVES and expr in SCHEME_PRIMITIVES:
        non_allowed_used[expr] += 1

def parse_scheme_file(file_path: str) -> Dict[str, int]:
    """Parse a Scheme file and return a dictionary of non-allowed primitives and undefined functions used."""
    with open(file_path, 'r') as file:
        content = file.read()
    
    # Remove comments
    content = re.sub(';.*$', '', content, flags=re.MULTILINE)
    
    tokens = tokenize(content)
    parsed = parse(tokens)
    
    defined_funcs = set()
    non_allowed_used = defaultdict(int)
    
    for expr in parsed:
        analyze_expression(expr, defined_funcs, set(), non_allowed_used)
    
    # Handle 'load' specially
    if 'load' in non_allowed_used:
        for expr in parsed:
            if isinstance(expr, list) and expr[0] == 'load':
                loaded_file = expr[1].strip('"')
                loaded_path = os.path.join(os.path.dirname(file_path), loaded_file)
                if os.path.exists(loaded_path):
                    loaded_non_allowed = parse_scheme_file(loaded_path)
                    for primitive, count in loaded_non_allowed.items():
                        non_allowed_used[primitive] += count
    
    return non_allowed_used

@click.command()
@click.argument('file_path', type=click.Path(exists=True))
def main(file_path: str) -> None:
    """
    Parse a Scheme file and report on non-allowed primitives and undefined function calls.

    This script reads a Scheme file, analyzes its content, and reports any non-allowed primitives
    (anything other than 'define' and 'lambda') or undefined function calls used in the file.

    Usage: python scheme_parser.py <path_to_lambda-calculus.scm>
    """
    non_allowed_used = parse_scheme_file(file_path)
    
    if not non_allowed_used:
        click.echo(click.style("No non-allowed primitives or undefined function calls found. The implementation appears to be pure lambda calculus!", fg="green"))
    else:
        click.echo(click.style("The following non-allowed primitives or potentially undefined function calls were found:", fg="yellow"))
        for item, count in non_allowed_used.items():
            if item in SCHEME_PRIMITIVES:
                click.echo(click.style(f"  {item}: {count} time(s) (Scheme primitive)", fg="red"))
            else:
                click.echo(f"  {item}: {count} time(s) (potentially undefined function)")
        click.echo(click.style("\nNote: Only 'define' and 'lambda' are allowed primitives in pure lambda calculus.", fg="yellow"))
        click.echo(click.style("Please review to ensure all other functions are properly defined within your implementation.", fg="yellow"))

if __name__ == "__main__":
    main()
