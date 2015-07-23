defmodule Tanx.TankUpdateTest do
  use ExUnit.Case

  setup do
    {:ok, game} = Tanx.Core.Game.start_link(clock_interval: nil,
      structure: %Tanx.Core.Structure{height: 20.0, width: 20.0})
    game |> Tanx.Core.Game.manual_clock_tick(1000)
    {:ok, player} = game |> Tanx.Core.Game.connect(name: "daniel")
    {:ok, game: game, player: player}
  end

  test "tank remains at rest", %{game: game, player: player} do
    :ok = player |> Tanx.Core.Player.new_tank()
    game |> Tanx.Core.Game.manual_clock_tick(2000)
    _check_tank(player, 0.0, 0.0, 0.0)
  end

  test "tank moves forward with constant velocity", %{game: game, player: player} do
    :ok = player |> Tanx.Core.Player.new_tank()
    :ok = player |> Tanx.Core.Player.control_tank(:forward, true)
    game |> Tanx.Core.Game.manual_clock_tick(2000)
    _check_tank(player, 2.0, 0.0, 0.0)
    game |> Tanx.Core.Game.manual_clock_tick(4000)
    _check_tank(player, 6.0, 0.0, 0.0)
  end

  test "tank stops at arena edge", %{game: game, player: player} do
    :ok = player |> Tanx.Core.Player.new_tank()
    :ok = player |> Tanx.Core.Player.control_tank(:forward, true)
    game |> Tanx.Core.Game.manual_clock_tick(5500)
    _check_tank(player, 9.0, 0.0, 0.0)
    game |> Tanx.Core.Game.manual_clock_tick(6000)
    _check_tank(player, 9.5, 0.0, 0.0)
    game |> Tanx.Core.Game.manual_clock_tick(6500)
    _check_tank(player, 9.5, 0.0, 0.0)
  end

  test "tank rotates with constant velocity", %{game: game, player: player} do
    :ok = player |> Tanx.Core.Player.new_tank()
    :ok = player |> Tanx.Core.Player.control_tank(:right, true)
    game |> Tanx.Core.Game.manual_clock_tick(1500)
    _check_tank(player, 0.0, 0.0, -1.0)
    game |> Tanx.Core.Game.manual_clock_tick(2500)
    _check_tank(player, 0.0, 0.0, -3.0)
  end


  # Utils

  defp _check_tank(player, x, y, heading) do
    view = player |> Tanx.Core.Player.view_arena()
    got = view.tanks |> hd()
    want = %Tanx.Core.View.Tank{is_me: true, name: "daniel", x: x, y: y, heading: heading}
    assert got == want
  end

end
