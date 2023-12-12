class SubscriptionDemoModel {
  String? planForMonth;
  String? plandescription;
  String? cost;
  String? internalNotesDesp;
  List<String>? benifitsDesp;
  String? description;

  SubscriptionDemoModel({
     this.planForMonth,
     this.plandescription,
     this.cost,
     this.internalNotesDesp,
     this.benifitsDesp,
     this.description,
  });
}

List<SubscriptionDemoModel> subscriptionPlan = [
  SubscriptionDemoModel(
      planForMonth: "Half yearly",
      plandescription:
          "Building Authenticity Into Relationships For A Happier Life We’ve all been there: forcing yourself to be a little more this or a little less that in order to fit in. It’s natural and healthy to show different sides of yourself to different people in your life. Your mom knows a different side of you than …",
      cost: "\$1080/ Half Yearly",
      internalNotesDesp: "Half Yearly Subscription",
      benifitsDesp: ["Half Yearly"],
      description: "description"),
  SubscriptionDemoModel(
      planForMonth: "Quarterly",
      plandescription:
          "Building Authenticity Into Relationships For A Happier Life We’ve all been there: forcing yourself to be a little more this or a little less that in order to fit in. It’s natural and healthy to show different sides of yourself to different people in your life. Your mom knows a different side of you than …",
      cost: "\$699/ Quarterly",
      internalNotesDesp: "Quarterly Subscription",
      benifitsDesp: ["Quarterly"],
      description: "description"),
  SubscriptionDemoModel(
      planForMonth: "Monthly",
      plandescription:
          "Building Authenticity Into Relationships For A Happier Life We’ve all been there: forcing yourself to be a little more this or a little less that in order to fit in. It’s natural and healthy to show different sides of yourself to different people in your life. Your mom knows a different side of you than …",
      cost: "\$200/ Monthly",
      internalNotesDesp: "Monthly Subscription",
      benifitsDesp: ["Goals", "Membership ", "Workshop", "TSU"],
      description: "description"),
];
