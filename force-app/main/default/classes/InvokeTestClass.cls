public with sharing class InvokeTestClass {
    @InvocableMethod(label='Get Enrolments' description='Iterate over students, classes and payments and create junction records')
    public static List<String> createEnrolments(List<String> request){
        
        //parse inputs and variables
       System.debug('Str'+request);
       return null;
    }
}