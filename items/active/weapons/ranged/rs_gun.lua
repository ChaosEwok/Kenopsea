require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/items/active/weapons/weapon.lua"

function init()
  if config.getParameter("passiveStatusEffects") then
    self.tagGroup = ("rs_" .. config.getParameter("itemName") .. activeItem.hand())
    status.addPersistentEffects(self.tagGroup, config.getParameter("passiveStatusEffects"))
  end

  activeItem.setCursor(config.getParameter("cursor", "/cursors/pointer.cursor"))
  animator.setGlobalTag("paletteSwaps", config.getParameter("paletteSwaps", ""))
 
  self.weapon = Weapon:new()

  self.weapon:addTransformationGroup("weapon", {0,0}, 0)
  self.weapon:addTransformationGroup("muzzle", self.weapon.muzzleOffset, 0)

  local primaryAbility = getPrimaryAbility()
  self.weapon:addAbility(primaryAbility)
  
  local secondaryAttack = getAltAbility(self.weapon.elementalType)
  if secondaryAttack then
    self.weapon:addAbility(secondaryAttack)
  end
 
  self.weapon:init()
end

function update(dt, fireMode, shiftHeld)
  self.weapon:update(dt, fireMode, shiftHeld)
end

function uninit()
  if config.getParameter("passiveStatusEffects") then
    status.clearPersistentEffects(self.tagGroup)
    if config.getParameter("statusEffectsLingerOnUnequip") then
	  status.addEphemeralEffects(config.getParameter("passiveStatusEffects"), activeItem.ownerEntityId())
	end
  end

  self.weapon:uninit()
end