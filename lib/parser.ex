defmodule Parser do
  def parse_program(token_list) do
    function = parse_function(token_list)

    case function do
      {{:error, error_message}, _rest} ->
        {:error, error_message}

      {function_node, rest} ->
        if rest == [] do
          {:program, function_node}
        else
          {:error, "Error: there are more elements after function end"}
        end
    end
  end

  def parse_function([next_token | rest]) do
    if next_token == :int_keyword do
      [next_token | rest] = rest

      if next_token == :main_keyword do
        [next_token | rest] = rest

        if next_token == :open_paren do
          [next_token | rest] = rest

          if next_token == :close_paren do
            [next_token | rest] = rest

            if next_token == :open_brace do
              statement = parse_statement(rest)

              case statement do
                {{:error, error_message}, rest} ->
                  {{:error, error_message}, rest}

                {statement_node, [next_token | rest]} ->
                  if next_token == :close_brace do
                    {{:function, :main, statement_node}, rest}
                  else
                    {{:error, "Error, close brace missed"}, rest}
                  end
              end
            else
              {:error, "Error: open brace missed"}
            end
          else
            {:error, "Error: close parentesis missed"}
          end
        else
          {:error, "Error: open parentesis missed"}
        end
      else
        {:error, "Error: main functionb missed"}
      end
    else
      {:error, "Error, return type value missed"}
    end
  end

  def parse_statement([next_token | rest]) do
    if next_token == :return_keyword do
      expression = parse_expression(rest)

      case expression do
        {{:error, error_message}, rest} ->
          {{:error, error_message}, rest}

        {exp_node, [next_token | rest]} ->
          if next_token == :semicolon do
            {{:return, exp_node}, rest}
          else
            {{:error, "Error: semicolon missed after constant to finish return statement"}, rest}
          end
      end
    else
      {{:error, "Error: return keyword missed"}, rest}
    end
  end

  def parse_expression([next_token | rest]) do
    case next_token do
      {:constant, value} -> {{:constant, :int, value}, rest}
      _ -> {{:error, "Error: constant value missed"}, rest}
    end
  end
end
