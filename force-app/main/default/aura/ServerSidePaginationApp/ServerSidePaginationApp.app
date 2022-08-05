<aura:application  extends="force:slds" > 
    <c:kanbanLWC objNm="Opportunity" pickListFieldName="StageName" flds="Id,Name,StageName" ></c:kanbanLWC>
    <!--c:ServerSidePaginationComponent/--> 
</aura:application>