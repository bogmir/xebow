defmodule RGBMatrix.Animation.RandomKeypresses do
  @moduledoc """
  Changes every key pressed to a random color.
  """

  use RGBMatrix.Animation

  alias Chameleon.HSV

  defmodule State do
    @moduledoc false
    defstruct [:led_ids, :dirty]
  end

  @impl true
  def new(leds, _config) do
    led_ids = Enum.map(leds, & &1.id)

    %State{
      led_ids: led_ids,
      # NOTE: as to not conflict with possible led ID of `:all`
      dirty: {:all}
    }
  end

  @impl true
  def render(state, _config) do
    %{led_ids: led_ids, dirty: dirty} = state

    colors =
      case dirty do
        {:all} -> Enum.map(led_ids, fn id -> {id, random_color()} end)
        id -> [{id, random_color()}]
      end

    {:never, colors, state}
  end

  defp random_color do
    HSV.new((:rand.uniform() * 360) |> trunc(), 100, 100)
  end

  @impl true
  def interact(state, _config, led) do
    {0, %{state | dirty: led.id}}
  end
end
