public without sharing class JiraDataCommon {
    public class JiraUser{
        public String name;
        public String emailAddress;
        public String accountId;
        public String displayName;
    }

    public class JiraSearchRequest{
        public List<String> expand;
        public String jql;
        public Integer maxResults;
        public Boolean fieldsByKeys;
        public List<String> fields;
        public Integer startAt;
    }

    /*
    * https://developer.atlassian.com/cloud/jira/platform/rest/v3/#api-rest-api-3-issue-issueIdOrKey-notify-post
    */
    public class JiraNotificationRequest{
        public String htmlBody;
        public String subject;
        public String textBody;
        public Map<String,Object> to;
    }

}