
-- === Setup === --

Settings:setCompareDimension(true, 1080)
Settings:setScriptDimension(true, 1080)
setAlternativeClick(true)

UNKNOWN = "unknown"
EXIT = "exit"
QUEST_LIST = "quest_list"
MISSION_LIST = "mission_list"
COMPANION_LIST = "companion_list"
DEPART_SCREEN = "depart_screen"
BATTLE = "battle"
FIGHTING = "fighting"
RESULTS = "results"
UNIT_RESULTS = "unit_results"
ITEMS_OBTAINED = "items_obtained"
DISCONNECTED = "disconnected"

TIMEOUT = 20
FIGHTING_TIMEOUT = 120

MAX_RETRY = 4

retries = 0

function main()
  state = QUEST_LIST

  while(true) do
    if (state == QUEST_LIST) then
      state = quest_list()
    elseif (state == MISSION_LIST) then
      state = mission_list()
    elseif (state == COMPANION_LIST) then
      state = companion_list()
    elseif (state == DEPART_SCREEN) then
      state = depart_screen()
    elseif (state == BATTLE) then
      state = battle()
    elseif (state == FIGHTING) then
      state = fighting()
    elseif (state == RESULTS) then
      state = results()
    elseif (state == UNIT_RESULTS) then
      state = unit_results()
    elseif (state == ITEMS_OBTAINED) then
      state = items_obtained()
    elseif (state == UNKNOWN) then
      state = unknown()
    elseif (state == DISCONNECTED) then
      state = disconnected()
    else
      break
    end

    wait(1)
  end
end

function unknown()
  if (retries > MAX_RETRY) then
    return EXIT
  end

  local found_state

  if (exists("disconnected/disconnected.png")) then
    found_state = DISCONNECTED
  elseif (exists("results/results.png")) then
    found_state = RESULTS
  elseif (exists("battle/battle.png")) then
    found_state = BATTLE
  elseif (exists("companion_list/companion_list.png")) then
    found_state = COMPANION_LIST
  elseif (exists("depart_screen/depart_screen.png")) then
    found_state = DEPART_SCREEN
  elseif (exists("fighting/fighting.png")) then
    found_state = FIGHTING
  elseif (exists("items_obtained/items_obtained.png")) then
    found_state = ITEMS_OBTAINED
  elseif (exists("mission_list/mission_list.png")) then
    found_state = MISSION_LIST
  elseif (exists("quest_list/quest_list.png")) then
    found_state = QUEST_LIST
  elseif (exists("unit_results/unit_results.png")) then
    found_state = UNIT_RESULTS
  else
    retries = retries + 1
    return UNKNOWN
  end

  retries = 0

  return found_state
end

function quest_list()
  if (existsClick("quest_list/earth_shrine_exit.png", TIMEOUT)) then
    return MISSION_LIST
  else
    return UNKNOWN
  end
end

function mission_list()
  if (existsClick("mission_list/next.png", TIMEOUT)) then
    return COMPANION_LIST
  else
    return UNKNOWN
  end
end

function companion_list()
  if (existsClick("companion_list/rank.png", TIMEOUT)) then
    return DEPART_SCREEN
  else
    return UNKNOWN
  end
end

function depart_screen()
  if (existsClick("depart_screen/depart.png", TIMEOUT)) then
    return BATTLE
  else
    return UNKNOWN
  end
end

function battle()
  if (existsClick("battle/auto.png", TIMEOUT)) then
    return FIGHTING
  else
    return UNKNOWN
  end
end

function fighting()
  if (waitVanish("fighting/fighting.png", FIGHTING_TIMEOUT)) then
    return RESULTS
  else
    return UNKNOWN
  end
end

function results()
  if (existsClick("results/next.png", TIMEOUT)) then
    return UNIT_RESULTS
  else
    return UNKNOWN
  end
end

function unit_results()
  if (existsClick("unit_results/results.png", TIMEOUT)) then
    return ITEMS_OBTAINED
  else
    return UNKNOWN
  end
end

function items_obtained()
  if (existsClick("items_obtained/next.png", TIMEOUT)) then
    return QUEST_LIST
  else
    return UNKNOWN
  end
end

function disconnected()
  if (existsClick("disconnected/ok.png", TIMEOUT)) then
    return UNKNOWN
  else
    return UNKNOWN
  end
end

main()
