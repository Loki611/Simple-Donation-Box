																		/************************************************************************
																				  Made by Loki611 (http://steamcommunity.com/id/Loki611)
																		***************************************************************************/

DONATIONBOX = {};

if(SERVER)then
	util.AddNetworkString("donationbox_Message");
	
	AddCSLuaFile("donationbox_config.lua");
	include("donationbox_config.lua");
	
	function DONATIONBOX.sendMessage(pls, message)
		if(!message || message == "")then return; end
		
		net.Start("donationbox_Message");
			net.WriteString(message);
		net.Send(pls);
	end
	
	hook.Add("Initialize", "DonationBox_checkDarkRP", function()
		if(DarkRP == nil || GAMEMODE_NAME != "darkrp")then
			ErrorNoHalt("["..DONATIONBOX.messageTag.."] Without darkrp installed this addon may not work properly.\n");
		end
	end)
	
	hook.Add("DonationBox_canTake", "DonationBox_canTakeDefault", function(pl, owner, amt)
		if(owner:IsValid())then
			if(DONATIONBOX.onlyOwnerTake && pl != owner && !table.HasValue(DONATIONBOX.overrideTakeList, pl:GetUserGroup()))then
				return false;
			end
		end
	end)
	
	hook.Add("DonationBox_canPickup", "DonationBox_canPickupDefault", function(pl, box, owner)
		if(DONATIONBOX.onlyOwnerPickup)then
			if(owner:IsValid() && owner != pl && !table.HasValue(DONATIONBOX.overridePickupList, pl:GetUserGroup()))then
				return false;
			end
		end
	end)
	
	hook.Add("GravGunPickupAllowed", "DonationBox_handlePickingUp", function(pl, ent)
		if(pl:IsValid() && ent:GetClass():lower() == "donation_box")then
			local owner = ent:Getowning_ent();
			local canPickup = hook.Call("DonationBox_canPickup", nil, pl, ent, owner);
			
			if(canPickup != nil && canPickup == false)then
				return false;
			end
		end
	end)
else
	include("donationbox_config.lua");
	
	surface.CreateFont("DonationBox_defaultFont", {
		font = "Arial",
		size = ScreenScale(DONATIONBOX.fontSize),
		weight = 700
	})
	
	net.Receive("donationbox_Message", function()
		local message = net.ReadString();
		
		local formatMessage = {
			color_white,
			"[",
			DONATIONBOX.messageTagColor,
			DONATIONBOX.messageTag,
			color_white,
			"] "..message
		}
		
		chat.AddText(unpack(formatMessage));
	end)
end