defmodule Tanx.PowerupUpdateTest do
  use ExUnit.Case

  setup do
    time_config = Tanx.Core.SystemTime.new_config
    {:ok, game} = Tanx.Core.Game.start_link(clock_interval: nil, time_config: time_config)
    {:ok, game: game, time_config: time_config}
  end

  test "powerup created", %{game: game} do
   {:ok, player} = game |> Tanx.Core.Game.connect(name: "Ben")
    game_state = game |> Tanx.Core.Game.get_state
    _powerup = Tanx.Core.ArenaObjects.create_power_up(game_state.arena_objects, {0.1, 1.0})
    :ok = game |> Tanx.Core.Game.manual_clock_tick(1000)
    want = %Tanx.Core.View.PowerUp{x: 0.1, y: 1.0, radius: 0.4, type: %Tanx.Core.PowerUpTypes.BouncingMissile{}}
    view = player |> Tanx.Core.Player.view_arena_objects()
    assert view.powerups |> hd() == want
  end

  test "destroyed tank creates powerup", %{game: game, time_config: time_conf} do
    #Create one player
    {:ok, player1} = game |> Tanx.Core.Game.connect(name: "Ben")
    :ok = player1 |> Tanx.Core.Player.new_tank()
    #move the player forward
    :ok = player1 |> Tanx.Core.Player.control_tank(:forward, true)
    time_conf |> Tanx.Core.SystemTime.set(1000)
    :ok = game |> Tanx.Core.Game.manual_clock_tick(1000)
    #create a second player
    {:ok, player2} = game |> Tanx.Core.Game.connect(name: "greg")
    :ok = player2 |> Tanx.Core.Player.new_tank()
    :ok = time_conf |> Tanx.Core.SystemTime.set(3000)
    :ok = game |> Tanx.Core.Game.manual_clock_tick(3000)

    #player one stops moving forward
    :ok = player1 |> Tanx.Core.Player.control_tank(:forward, false)
    #player 2 shoots at player 1
    assert :ok == player2 |> Tanx.Core.Player.new_missile()
    :ok = time_conf |> Tanx.Core.SystemTime.set(3500)
    :ok = game |> Tanx.Core.Game.manual_clock_tick(3500)
    assert :ok == player2 |> Tanx.Core.Player.new_missile()
    :ok = time_conf |> Tanx.Core.SystemTime.set(4000)
    :ok = game |> Tanx.Core.Game.manual_clock_tick(4000)
    assert :ok == player2 |> Tanx.Core.Player.new_missile()
    :ok = time_conf |> Tanx.Core.SystemTime.set(5500)
    :ok = game |> Tanx.Core.Game.manual_clock_tick(5500)
    #Check player 1 is destroyed and only 2 remains
    want = %Tanx.Core.View.Tank{is_me: true,
                                name: "greg",
                                armor: 1.0,
                                x: 0.0,
                                y: 0.0,
                                heading: 0.0}
    view = player2 |> Tanx.Core.Player.view_arena_objects()
    assert view.tanks |> hd() == want

    wanted_power_up = %Tanx.Core.View.PowerUp{
      radius: 0.4,
      type: %Tanx.Core.PowerUpTypes.BouncingMissile{
        name: "Bouncing Missile"
      },
      x: 6.0,
      y: 0.0
    }
    assert view.powerups |> hd() == wanted_power_up
  end

  test "tank collects power up", %{game: game, time_config: time_conf} do
    game_state = game |> Tanx.Core.Game.get_state
    _powerup = Tanx.Core.ArenaObjects.create_power_up(game_state.arena_objects, {3.0, 0.0})
    :ok = game |> Tanx.Core.Game.manual_clock_tick(1000)
    {:ok, player} = game |> Tanx.Core.Game.connect(name: "Ben")
    :ok = player |> Tanx.Core.Player.new_tank()
    want = %Tanx.Core.View.PowerUp{x: 3.0, y: 0.0, radius: 0.4, type: %Tanx.Core.PowerUpTypes.BouncingMissile{}}
    view = player |> Tanx.Core.Player.view_arena_objects()
    assert view.powerups |> hd() == want
    :ok = player |> Tanx.Core.Player.control_tank(:forward, true)
    time_conf |> Tanx.Core.SystemTime.set(2500)
    :ok = game |> Tanx.Core.Game.manual_clock_tick(2500)
    view = player |> Tanx.Core.Player.view_arena_objects()
    assert view.powerups == []
    player_powerups = player |> Tanx.Core.Player.get_powerups()
    want = %{ wall_bounce: 1 }
    assert player_powerups == want
  end

end