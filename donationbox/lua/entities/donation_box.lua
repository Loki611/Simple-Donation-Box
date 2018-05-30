																		/************************************************************************
																				  Made by Loki611 (http://steamcommunity.com/id/Loki611)
																		***************************************************************************/
ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.PrintName = "Donation Box";
ENT.Author = "Loki611";
ENT.Spawnable = true;
ENT.Category = "DonationBox";

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent"); // Darkrp compatibility
	self:NetworkVar("Int", 0, "Holdings");
	self:NetworkVar("Int", 1, "HighestDonation");
end

if(SERVER)then
	AddCSLuaFile();
	AddCSLuaFile("donationbox_config.lua");

	function ENT:Initialize()
		// TODO: Make more models.
		self:SetModel("models/props/cs_militia/footlocker01_open.mdl");
		self:PhysicsInit(SOLID_VPHYSICS);
		self:SetMoveType(MOVETYPE_VPHYSICS);
		self:SetSolid(SOLID_VPHYSICS);
		self:SetUseType(SIMPLE_USE);
		self:SetHoldings(0);
		self:SetHighestDonation(0);
		self.health = DONATIONBOX.health || 0;
		
		local phys = self:GetPhysicsObject();
		if(phys:IsValid())then
			phys:Wake();
		end
	end

	function ENT:StartTouch(ent)
		if(ent:GetClass() == "spawned_money")then
			local add = ent:Getamount();
			self:SetHoldings(self:GetHoldings() + add);
			ent:Remove();
			
			local newTotal = hook.Call("DonationBox_onMoneyAdded", nil, self, add);
			if(newTotal != nil && string.lower(type(newTotal) || "") == "number")then
				add = newTotal;
			end
			
			if(add > self:GetHighestDonation())then
				self:SetHighestDonation(add);
			end

			if(self:Getowning_ent():IsValid())then
				local mainStr = DONATIONBOX.addedMoneyText || "{AMOUNT} has been added to your donation box.";
				local totalStr = ((DarkRP && DarkRP.formatMoney(add)) || "$"..add);
				
				DONATIONBOX.sendMessage(self:Getowning_ent(), string.Replace(mainStr, "{AMOUNT}", totalStr));
			end
		end
	end
	
	function ENT:OnTakeDamage(dmg)
		self.health = self.health - dmg:GetDamage();

		if (self.health <= 0) then
			if(DONATIONBOX.explodeOnDestroy)then
				local effect = EffectData();
				effect:SetOrigin(self:GetPos());
				effect:SetMagnitude(2);
				effect:SetScale(2);
				effect:SetRadius(3);
				util.Effect("Explosion", effect);
			end
			
			self:Remove();
		end
	end

	function ENT:Use(_, caller)
		if(caller.addMoney)then
			local owner = self:Getowning_ent();
			
			if(self:GetHoldings() < DONATIONBOX.minTakeAmount)then
				DONATIONBOX.sendMessage(caller, DONATIONBOX.notEnoughText || "Not enough money to take!");
				return;
			end
			
			local canTake, reason = hook.Call("DonationBox_canTake", nil, caller, owner, self:GetHoldings(), self);
			if(canTake != nil && !canTake)then
				DONATIONBOX.sendMessage(caller, reason || DONATIONBOX.cannotTakeText);
				return;
			end
			
			local total = self:GetHoldings();
			local calcTotal = hook.Call("DonationBox_calcTotal", nil, caller, owner, total, self);
			if(calcTotal != nil)then
				total = calcTotal;
			end
			
			caller:addMoney(total);
			self:SetHoldings(0);
				
			hook.Call("DonationBox_tookMoney", nil, caller, total, self, owner);
			DONATIONBOX.sendMessage(caller, string.Replace(DONATIONBOX.takeMoneyText || "You took {AMOUNT}", "{AMOUNT}", ((DarkRP && DarkRP.formatMoney(total)) || "$"..total)));
		end
	end

	function ENT:OnRemove()
		
	end
elseif(CLIENT)then
	function ENT:Draw()
		self:DrawModel();
		
		local pos = self:GetPos();
		local ang = self:GetAngles();

		local owner = self:Getowning_ent();
		owner = (IsValid(owner) && owner:Nick()) || "World";
		owner = string.Replace(DONATIONBOX.nameText, "{USERNAME}", owner); 
		
		local holding = self:GetHoldings() || 0;
		local replace =  ((DarkRP && DarkRP.formatMoney(holding)) || "$"..tostring(holding));
		local holdingTxt = string.Replace(((DONATIONBOX.holdingText!=nil && DONATIONBOX.holdingText) || "Holding: {AMOUNT}"), "{AMOUNT}", replace);
		
		surface.SetFont("DonationBox_defaultFont");
		local nameW, nameH = surface.GetTextSize(owner);
		local holdingW, holdingH = surface.GetTextSize(holdingTxt);
		
		local nameCol = DONATIONBOX.nameTextColor || Color(255, 255, 255);
		local holdCol = DONATIONBOX.holdingsTextColor || Color(255, 255, 255);
		local nameBoxCol = DONATIONBOX.nameTextBoxColor || Color(0, 0, 0, 0);
		local holdingBoxCol = DONATIONBOX.holdingsTextBoxColor || Color(0, 0, 0, 0);
		
		ang:RotateAroundAxis(ang:Right(), 90);
		ang:RotateAroundAxis(ang:Up(), 90);
		ang:RotateAroundAxis(ang:Forward(), 180);
		
		cam.Start3D2D(pos + ang:Up() * 1.5 + ang:Up() * -18, ang, 0.11);
			draw.WordBox(2, -nameW/2, -225, owner, "DonationBox_defaultFont", nameBoxCol, nameCol)
			draw.WordBox(2, -holdingW/2, -225 + (nameH * 1.1), holdingTxt, "DonationBox_defaultFont", holdingBoxCol, holdCol);
			
			if(DONATIONBOX.showHighestDonation)then
				local highReplace =  ((DarkRP && DarkRP.formatMoney(self:GetHighestDonation())) || "$"..tostring(self:GetHighestDonation()));
				local highText = string.Replace(DONATIONBOX.highestDonationText, "{AMOUNT}", highReplace);
				local highestTextW, highestTextH = surface.GetTextSize(highText);
				
				draw.WordBox(2, -highestTextW/2, -225 + (nameH * 1.1) + (holdingH * 1.1), highText, "DonationBox_defaultFont", DONATIONBOX.highestDonationBoxColor, DONATIONBOX.highestDonationTextColor);
			end

		cam.End3D2D();
	end
end