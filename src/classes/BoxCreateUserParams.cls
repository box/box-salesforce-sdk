/**
 * Contains optional parameters for creating a new enterprise user on Box.
 */

public class BoxCreateUserParams {

    public Boolean canSeeManagedUsers {get; set;}
    public Boolean isExemptFromDeviceLimits {get; set;}
    public Boolean isExemptFromLoginVerification {get; set;}
    public Boolean isPlatformAccessOnly {get; set;}
    public Boolean isSyncEnabled {get; set;}
    public BoxUser.Role role {get; set;}
    public BoxUser.Status status {get; set;}
    public long spaceAmount {get; set;}
    public String address {get; set;}
    public String jobTitle {get; set;}
    public String language {get; set;}
    public String phone {get; set;}
    public String timezone {get; set;}

    public BoxCreateUserParams() {
    }
}