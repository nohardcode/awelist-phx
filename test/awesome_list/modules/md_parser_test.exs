defmodule AwesomeList.MdParserTest do
  use ExUnit.Case
  alias AwesomeList.MdParser

  @expected [
    {"Other repos", "<p>Just have fun!</p>",
     [
       %{
         description:
           "A collaborative, real-time video fact-checking platform. (<a href=\"https://captainfact.io/\">  Docs</a>).",
         link: {"CaptainFact", "https://github.com/CaptainFact/captain-fact-api"}
       },
       %{
         description: "Helpers for confusing - people",
         link: {"wtf", "https://github.com/some_user/wtf"}
       },
       %{
         description: "Oops string generator.",
         link: {"oops", "https://github.com/nohardcode/oops"}
       }
     ]},
    {"Actors", "<p>Libraries and tools for working with actors and such.</p>",
     [
       %{
         description: "Helpers for easier implementation of actors in Elixir.",
         link: {"exactor", "https://github.com/sasa1977/exactor"}
       },
       %{
         description: "Pipelined flow processing engine.",
         link: {"dflow", "https://github.com/dalmatinerdb/dflow"}
       }
     ]}
  ]

  setup do
    api = Application.get_env(:awesome_list, :file_fetch_api)
    url = Application.get_env(:awesome_list, :github_awesome_repo)
    {_, markdown} = api.fetch_raw_file(url)
    {:ok, markdown: markdown}
  end

  test "should return expected structure", %{markdown: markdown} do
    assert markdown |> MdParser.parse() == @expected
  end

  test "should have correct categories length", %{markdown: markdown} do
    assert markdown |> MdParser.parse() |> length == 2
  end
end
