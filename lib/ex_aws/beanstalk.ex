defmodule ExAws.Beanstalk do
  @moduledoc """
  Operations on AWS Elastic Beanstalk
  """

  import ExAws.Utils

  @version "2010-12-01"

  @doc "Retrieves a list of all of the Beanstalk Applications"
  @spec describe_applications() :: ExAws.Operation.Query.t
  def describe_applications(opts \\ []), do: fetch_using_opts(:describe_applications, opts)

  @doc "Retrieves a list of environments for an application."
  def describe_environments(opts \\ []), do: fetch_using_opts(:describe_environments, opts)

  @doc "Retrieves a list of application versions for an application."
  def describe_application_versions(opts \\ []), do: fetch_using_opts(:describe_application_versions, opts)

  def describe_configuration_options(opts \\ []), do: fetch_using_opts(:describe_configuration_options, opts)

  def describe_configuration_settings(opts \\ []), do: fetch_using_opts(:describe_configuration_settings, opts)

  def describe_environment_health(environment_name, opts \\ []) do
    {attrs, opts} = opts |> Keyword.pop(:attribute_names, [])

    params = attrs
    |> format_list_opts(:attribute_names)
    |> Map.merge(format_regular_opts(opts))
    |> Map.put("EnvironmentName", environment_name)

    request("", :describe_environment_health, params)
  end

  defp fetch_using_opts(service, opts) do
    params = opts |> format_regular_opts
    request("", service, params)
  end

  defp request(queue, action, params) do
    action_string = action |> Atom.to_string |> Macro.camelize

    %ExAws.Operation.Query{
      path: "/" <> queue,
      params: params |> Map.put("Action", action_string),
      service: :elasticbeanstalk,
      action: action,
      parser: &ExAws.Beanstalk.Parsers.parse/2
    }
  end

  defp format_regular_opts(opts) do
    opts |> Enum.into(%{}, fn {k, v} ->
        {format_param_key(k), v}
    end)
  end

  defp format_list_opts(list, key) do
    k = key |> Atom.to_string |> ExAws.Utils.camelize

    list
    |> Enum.with_index
    |> Enum.map(fn {item, index} ->
      list_key = "#{k}.member.#{index+1}"
      Map.put(%{}, list_key, format_param_key(item))
    end)
    |> Enum.reduce(%{}, &Map.merge(&1, &2))
  end

  defp format_param_key("*"), do: "*"
  defp format_param_key(key) do
    key
    |> Atom.to_string
    |> ExAws.Utils.camelize
  end
end
