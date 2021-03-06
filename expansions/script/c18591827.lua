--"Sebastian, the Prince of the Assassins"
local m=18591827
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Xyz Materials
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x50e),5,2)
    c:EnableReviveLimit()
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18591827,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c18591827.condition)
    e1:SetCost(c18591827.cost)
    e1:SetTarget(c18591827.target)
    e1:SetOperation(c18591827.operation)
    c:RegisterEffect(e1)
    --atk limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetValue(c18591827.atlimit)
    c:RegisterEffect(e2)
end
function c18591827.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP()
end
function c18591827.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c18591827.filter(c)
    return c:IsFaceup() and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c18591827.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c18591827.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c18591827.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c18591827.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c18591827.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(1)
        tc:RegisterEffect(e1)
    end
end
function c18591827.atlimit(e,c)
    return c~=e:GetHandler()
end