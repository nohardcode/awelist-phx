defmodule AwesomeListWeb.PageControllerTest do
  use AwesomeListWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200)
    assert conn.assigns.list == AwesomeList.Storage.get_list()
  end

  test "GET /?min_stars=50", %{conn: conn} do
    conn = get(conn, "/?min_stars=50")
    assert html_response(conn, 200)
    assert conn.assigns.list == AwesomeList.Storage.get_list(50)
  end

  test "GET /?min_stars=some_string", %{conn: conn} do
    conn = get(conn, "/?min_stars=some_string")
    assert html_response(conn, 200)
    assert conn.assigns.list == AwesomeList.Storage.get_list()
  end

  test "should redirect", %{conn: conn} do
    conn = get(conn, "/some_path")
    assert html_response(conn, 302)
    assert redirected_to(conn, 302) =~ "/"
  end

  test "should redirect from any path", %{conn: conn} do
    conn = get(conn, "/some_path/inner_path/?query=test")
    assert html_response(conn, 302)
    assert redirected_to(conn, 302) =~ "/"
  end
end
