<aura:application extends="force:slds">
    <aura:attribute name="options" type="List" default='[{label:"anjali",value:"anjali123"},
                                                        {label:"himgiree",value:"him123"},
                                                        {label:"yash",value:"yash123"},
                                                        {label:"tanmay",value:"tanmay123"},
                                                        ]'/>
<c:multiselect options="{!v.options}" disabled="false" minChar="3" multiSelect="true" label="Enter a Value"></c:multiselect>
</aura:application>