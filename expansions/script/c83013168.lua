--Seatector Soldier
--Keddy was here~
local function ID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cod.eqtg)
	e1:SetOperation(cod.eqop)
	c:RegisterEffect(e1)
	--Unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cod.sptg)
	e2:SetOperation(cod.spop)
	c:RegisterEffect(e2)
	--Destroy substitute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e3:SetValue(cod.repval)
	c:RegisterEffect(e3)
	--Equip Limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(cod.eqlimit)
	c:RegisterEffect(e4)
	--Cannot Banish
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e5)
	--Special Summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetRange(LOCATION_HAND)
	e6:SetCountLimit(1,id)
	e6:SetCost(cod.spcost)
	e6:SetCondition(cod.spcon)
	e6:SetTarget(cod.sptg2)
	e6:SetOperation(cod.spop2)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
end

--Equip
function cod.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and ct2==0
end
function cod.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cod.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cod.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cod.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(id,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cod.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not cod.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end

--Special Summon
function cod.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(id,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cod.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
--Replace Value
function cod.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end

--Equip Limit
function cod.eqlimit(e,c)
	return (c:IsAttribute(ATTRIBUTE_WATER) or e:GetHandler():GetEquipTarget()==c)
end

--Special Summon 2
function cod.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable()
end
function cod.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cod.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,cod.costfilter,1,1,REASON_COST,e:GetHandler())
end
function cod.cfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_UNION) and c:IsAttribute(ATTRIBUTE_WATER)
end
function cod.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cod.cfilter,1,nil,tp)
end
function cod.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(id,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cod.eqfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_UNION)
end
function cod.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(cod.eqfilter,tp,LOCATION_HAND,0,nil)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()==0 then return end
		local tc=sg:GetFirst()
		if c:IsFacedown() or not cod.filter(c) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
			return
		end
		if not Duel.Equip(tp,tc,c,true) then return end
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
		aux.SetUnionState(tc)
	elseif Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end