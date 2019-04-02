defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  setup_all do
    {:ok,
     tokens: [
       :int_keyword,
       :main_keyword,
       :open_paren,
       :close_paren,
       :open_brace,
       :return_keyword,
       {:constant, 2},
       :semicolon,
       :close_brace
     ]}
  end

  test "elements separated just by spaces", state do
    assert Lexer.scan_words(["int", "main(){return", "2;}"]) == state[:tokens]
  end

  test "function name separated of function body", state do
    assert Lexer.scan_words(["int", "main()", "{return", "2;}"]) == state[:tokens]
  end

  test "everything is separated", state do
    assert Lexer.scan_words(["int", "main", "(", ")", "{", "return", "2", ";", "}"]) ==
             state[:tokens]
  end
end
