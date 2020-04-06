defmodule AtEx.Gateway.Application do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API
  Application Data endpoint, use it to POST and GET requests to the Application endpoint
  """

  use AtEx.Gateway.Base,
    url:
      if(Application.get_env(:at_ex, :endpoint, "sandbox") === "sandbox",
        do: "https://api.sandbox.africastalking.com/version1",
        else: "https://api.africastalking.com/version1"
      )

  @doc """
  Collects application data from Africas Talking endpoint, Use this function to collect
  Data about your application

  ## Parameters
  * `none`

  ## Examples
      iex> AtEx.Gateway.Application.get_data()
  """
  @spec get_data :: {:ok, map()} | {:error, term()}
  def get_data do
    username = Application.get_env(:at_ex, :username)

    params =
      %{}
      |> Map.put(:username, username)

    with {:ok, %{status: 200} = res} <- get("/user", query: params) do
      {:ok, Jason.decode!(res.body)}
    else
      {:ok, val} ->
        {:error, %{status: val.status, message: val.body}}

      {:error, message} ->
        {:error, message}
    end
  end
end
