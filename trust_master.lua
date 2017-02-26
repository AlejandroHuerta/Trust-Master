
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
ENERGY_RECOVERY = "energy_recovery"
LAPIS_RESTORE = "lapis_restore"
UNIT_DATA = "unit_data"
DAILY_QUEST = "daily_quest"
FRIEND_REQUEST = "friend_request"

TIMEOUT = 20
FIGHTING_TIMEOUT = 120
ENERGY_WAIT = 60 * 5 * 10

RETRY_TIMEOUT = 5
MAX_RETRY = 12

retries = 0

use_lapis = false

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
  elseif (exists("results/results.png", RETRY_TIMEOUT)) then
    found_state = RESULTS
  elseif (exists("battle/battle.png", RETRY_TIMEOUT)) then
    found_state = BATTLE
  elseif (exists("energy_recovery/energy_recovery.png", RETRY_TIMEOUT)) then
    found_state = ENERGY_RECOVERY
  elseif (exists("lapis_restore/lapis_restore.png", RETRY_TIMEOUT)) then
    found_state = LAPIS_RESTORE
  elseif (exists("unit_data/unit_data.png", RETRY_TIMEOUT)) then
    found_state = UNIT_DATA
  elseif (exists("companion_list/companion_list.png", RETRY_TIMEOUT)) then
    found_state = COMPANION_LIST
  elseif (exists("depart_screen/depart_screen.png", RETRY_TIMEOUT)) then
    found_state = DEPART_SCREEN
  elseif (exists("fighting/fighting.png", RETRY_TIMEOUT)) then
    found_state = FIGHTING
  elseif (exists("items_obtained/items_obtained.png", RETRY_TIMEOUT)) then
    found_state = ITEMS_OBTAINED
  elseif (exists("mission_list/mission_list.png", RETRY_TIMEOUT)) then
    found_state = MISSION_LIST
  elseif (exists("quest_list/quest_list.png", RETRY_TIMEOUT)) then
    found_state = QUEST_LIST
  elseif (exists("unit_results/unit_results.png", RETRY_TIMEOUT)) then
    found_state = UNIT_RESULTS
  elseif (exists("daily_quest/daily_quest.png", RETRY_TIMEOUT)) then
    found_state = DAILY_QUEST
  elseif (exists("friend_request/friend_request.png", RETRY_TIMEOUT)) then
    found_state = FRIEND_REQUEST
  else
    retries = retries + 1
    return UNKNOWN
  end

  retries = 0

  return found_state
end

function daily_quest()
  if (existsClick("daily_quest/close.png", TIMEOUT)) then
    return QUEST_LIST
  else
    return UNKNOWN
  end
end

function friend_request()
  if (existsClick("friend_request/dont_request.png", TIMEOUT)) then
    return QUEST_LIST
  else
    return UNKNOWN
  end
end

function unit_data()
  if (existsClick("unit_data/ok.png", TIMEOUT)) then
    return UNKNOWN -- Update
  else
    return UNKNOWN
  end
end

function lapis_restore()
  if (existsClick("lapis_restore/yes.png", TIMEOUT)) then
    return QUEST_LIST
  else
    return UNKNOWN
  end
end

function energy_recovery()
  if (use_lapis) then
    if (existsClick("energy_recovery/lapis.png", TIMEOUT)) then
      return LAPIS_RESTORE
    else
      return UNKNOWN
    end
  end

  wait(ENERGY_WAIT)

  if (existsClick("energy_recovery/back.png", TIMEOUT)) then
    return QUEST_LIST
  else
    return UNKNOWN
  end
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
