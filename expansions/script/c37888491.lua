--Celestian Spirit Fox
function c37888491.initial_effect(c)
    --send replace
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCondition(c37888491.repcon)
    e1:SetOperation(c37888491.repop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(37888491,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,37888491)
    e2:SetCost(c37888491.tfcost)
    e2:SetTarget(c37888491.tftg)
    e2:SetOperation(c37888491.tfop)
    c:RegisterEffect(e2)
    --effect gain
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(37888491,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c37888491.tfcost)
    e3:SetTarget(c37888491.sptg)
    e3:SetOperation(c37888491.spop)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetCondition(c37888491.efcon)
    e4:SetTarget(c37888491.eftg)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
end
function c37888491.repcon(e)
    local c=e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c37888491.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_TURN_SET)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
end
function c37888491.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_COST)
end
function c37888491.tffilter(c)
    return c:IsSetCard(0xebb) and c:IsLevelAbove(2) and not c:IsForbidden()
end
function c37888491.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c37888491.tffilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c37888491.tfop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c37888491.tffilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_TURN_SET)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
    end
end
function c37888491.efcon(e)
    return e:GetHandler():IsType(TYPE_SPELL+TYPE_CONTINUOUS) and e:GetHandler():IsFaceup() and not e:GetHandler():IsType(TYPE_EQUIP)
end
function c37888491.eftg(e,c)
    local g=e:GetHandler():GetColumnGroup(1,1)
    return c:IsType(TYPE_EFFECT) and c:IsSetCard(0xebb) and c:GetSequence()<5 and g:IsContains(c)
end
function c37888491.spfilter(c,e,tp)
    return c:IsSetCard(0xebb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c37888491.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c37888491.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c37888491.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c37888491.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c37888491.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c37888491.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_DECK)
end