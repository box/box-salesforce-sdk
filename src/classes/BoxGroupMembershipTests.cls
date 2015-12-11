@IsTest
public class BoxGroupMembershipTests {
	public static testmethod void testParseRole() {
		System.assertEquals(BoxGroupMembership.Role.ADMIN, BoxGroupMembership.parseRole('admin'));
		System.assertEquals(BoxGroupMembership.Role.MEMBER, BoxGroupMembership.parseRole('member'));
		System.assertEquals(null, BoxGroupMembership.parseRole('invalid_valie'));
	}
	 
	public static testmethod void testGetRoleAsString() {
	 	System.assertEquals('admin', BoxGroupMembership.getRoleAsString(BoxGroupMembership.Role.ADMIN));
	 	System.assertEquals('member', BoxGroupMembership.getRoleAsString(BoxGroupMembership.Role.MEMBER));
	 	System.assertEquals(null, BoxGroupMembership.getRoleAsString(null));
	}
     
    public static testmethod void testParseMember() {
     	BoxApiConnection api = new BoxApiConnection('accesstoken');
		BoxGroupMembership groupMembership = new BoxGroupMembership(api,'10543463');
		BoxGroupMembership.Info groupMembershipInfo = new BoxGroupMembership.Info();
		
		Test.startTest();
		groupMembershipInfo.parseMember('role', 'member');
        Test.stopTest();

		System.assertEquals(BoxGroupMembership.Role.MEMBER, groupMembershipInfo.role);
    }
      
    public static testmethod void testGetMembership() {
      	String mockResponseBody = BoxTestJsonResponseFactory.BOXGROUPMEMBERSHIP_GET_MEMBERSHIP;
      	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
      	BoxApiConnection api = new BoxApiConnection('accessToken');
      	
      	Test.startTest();
      	BoxGroupMembership membership = new BoxGroupMembership(api, '1560354');
      	BoxGroupMembership.Info membershipInfo = membership.getMembership();
      	Test.stopTest();
      	
      	System.assertEquals('member', membershipInfo.getValue('role'));
    }
    
    public static testmethod void testUpdateMembership() {
    	map<String, String> updatedFields = new map<String, String>();
    	updatedFields.put('role', 'admin');
    	String mockResponseBody = BoxTestJsonResponseFactory.getModifiedResponse(BoxTestJsonResponseFactory.BOXGROUPMEMBERSHIP_GET_MEMBERSHIP, updatedFields);
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	
    	Test.startTest();
    	BoxGroupMembership membership = new BoxGroupMembership(api, '1560354');
    	
    	BoxGroupMembership.Info infoToUpdate = new BoxGroupMembership.Info();
    	infoToUpdate.addValue('id', '1560354');
    	infoToUpdate.addValue('role', 'admin');
    	
    	BoxGroupMembership.Info updatedMembershipInfo = membership.updateMembership(infoToUpdate);
    	Test.stopTest();
    	
    	system.assertEquals('admin', BoxGroupMembership.getRoleAsString(updatedMembershipInfo.role));
    	system.assertEquals('group_membership', updatedMembershipInfo.type);
    }
    
    public static testmethod void testDeleteMembership() {
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(null, 'OK', 204));
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	
    	Test.startTest();
    	BoxGroupMembership membership = new BoxGroupMembership(api, '1560354');
    	Boolean deleted = membership.deleteMembership();
    	Test.stopTest();
    	
    	System.assertEquals(true, deleted);
    }
    
    public static testmethod void testGetObjectType() {
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	
    	Test.startTest();
    	BoxGroupMembership membership = new BoxGroupMembership(api, '1560354');
    	String objectType = membership.getObjectType();
    	Test.stopTest();
    	
    	System.assertEquals('group_membership', objectType);
    }
    
    public static testmethod void testSetInfo() {
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	
    	Test.startTest();
    	BoxGroupMembership membership = new BoxGroupMembership(api, '1560354');
    	BoxGroupMembership.Info membershipInfo = new BoxGroupMembership.Info(BoxTestJsonResponseFactory.BOXGROUPMEMBERSHIP_GET_MEMBERSHIP);
    	membership.setInfo(membershipInfo);
    	Test.stopTest();
    	
    	System.assertEquals(membership.getId(), membership.getInfo().getValue('id'));
    }
    
    public static testmethod void testInfoConstructors() {
    	String mockResponseBody = BoxTestJsonResponseFactory.BOXGROUPMEMBERSHIP_GET_MEMBERSHIP;
		BoxApiConnection api = new BoxApiConnection('accesstoken');
		
		Test.startTest();
		BoxGroupMembership.Info responseFromJsonString = new BoxGroupMembership.Info(mockResponseBody);
		BoxGroupMembership.Info responseFromNoParams = new BoxGroupMembership.Info();
    	BoxGroupMembership.Info responseFromJsonObject = new BoxGroupMembership.Info(responseFromJsonString);
    	Test.stopTest();
    	
        BoxGroupMembership membershipFromJsonString = new BoxGroupMembership(api, '1560354');
        membershipFromJsonString.setInfo(responseFromJsonString);
        BoxGroupMembership membershipFromJsonObject = new BoxGroupMembership(api, '1560354');
        membershipFromJsonObject.setInfo(responseFromJsonObject);
        System.assert(membershipFromJsonString.equalTo(membershipFromJsonObject));
        System.assertEquals(responseFromJsonString.getValue('id'), responseFromJsonObject.getValue('id'));
        System.assert(responseFromNoParams.children.size() == 0);
    }
    
    
    
}