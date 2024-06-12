# 03

```mermaid
flowchart TD
    subgraph 病人用户需求分类表
        普通病人 -->|高优先级| 需要基本的预约挂号功能能够查看医生排班并选择合适时间进行预约.
        普通病人 -->|中优先级| 希望系统能提供清晰的费用明细和在线支付功能简化缴费流程.
        普通病人 -->|低优先级| 需要系统支持查看历史问诊记录和电子病历便于追踪病情和治疗过程.
        老年病人 -->|高优先级| 需要系统界面简洁易用字体放大功能方便老年人操作.
        老年病人 -->|中优先级| 希望系统能提供语音输入功能减少打字困难.
        老年病人 -->|低优先级| 需要系统提供大字体高对比度的显示选项保护视力.
        慢性病病人 -->|高优先级| 需要系统能定期提醒药物服用和复诊时间.
        慢性病病人 -->|中优先级| 希望系统能管理多种药物的用药计划和相互作用提示.
        慢性病病人 -->|低优先级| 需要系统提供健康数据追踪功能如血压血糖记录.
    end

    subgraph 专家用户需求分类表
        医疗专家 -->|高优先级| 需要系统能管理复杂的日程安排包括手术会议和学术活动.
        医疗专家 -->|中优先级| 希望系统能与其他医疗信息系统无缝对接方便查看病人资料和检查结果.
        医疗专家 -->|低优先级| 需要系统提供数据分析功能帮助进行医疗研究和病例统计.
        医院管理员 -->|高优先级| 需要系统能进行医生排班和资源管理.
        医院管理员 -->|中优先级| 希望系统能监控医疗服务质量收集和分析病人评价.
        医院管理员 -->|低优先级| 需要系统提供财务报告和预算管理功能.
    end

    subgraph 医疗预约管理系统功能
        病人用户需求分类表 -->|满足需求| 医疗预约管理系统
        专家用户需求分类表 -->|满足需求| 医疗预约管理系统
    end

```



# 04.2

```
@startuml
[*] --> 登录系统

state 登录系统 {
    [*] --> 用户访问登录页面
    用户访问登录页面 --> 用户输入账号密码: 输入账号密码
    用户输入账号密码 --> 登录成功: 验证成功
    登录成功 --> [*]
    用户输入账号密码 --> 登录失败: 验证失败
    登录失败 --> [*]
}

登录系统 --> 服务选择

state 服务选择 {
    [*] --> 查看医生列表
    [*] --> 查询处方
    [*] --> 访问电子病历
    [*] --> 参与医疗服务评价
    [*] --> 查看科室信息
    [*] --> 预约挂号与问诊服务
    [*] --> 时段灵活性与个性化预约
    [*] --> 医疗费用账单管理
    [*] --> 缴费与退费流程
    查看医生列表 --> [*]
    查询处方 --> [*]
    访问电子病历 --> [*]
    参与医疗服务评价 --> [*]
    查看科室信息 --> [*]
    预约挂号与问诊服务 --> [*]
    时段灵活性与个性化预约 --> [*]
    医疗费用账单管理 --> [*]
    缴费与退费流程 --> [*]
}

服务选择 --> 预约挂号与问诊服务
预约挂号与问诊服务 --> 完成问诊 : 完成问诊
完成问诊 --> 电子问诊单与后续跟进 : 接收电子问诊单
电子问诊单与后续跟进 --> [*] : 结束

服务选择 --> 时段灵活性与个性化预约
时段灵活性与个性化预约 --> 预约成功 : 确认预约
预约成功 --> [*] : 结束

服务选择 --> 缴费与退费流程
缴费与退费流程 --> 完成支付 : 完成在线支付
完成支付 --> [*] : 结束

服务选择 --> 医疗费用账单管理
医疗费用账单管理 --> 查看费用账单 : 查看账单
查看费用账单 --> [*] : 结束

服务选择 --> 查询处方
查询处方 --> 查看处方详情 : 查看详情
查看处方详情 --> [*] : 结束

服务选择 --> 访问电子病历
访问电子病历 --> 查看病历详情 : 查看详情
查看病历详情 --> [*] : 结束

服务选择 --> 参与医疗服务评价
参与医疗服务评价 --> 提交评价 : 填写并提交评价
提交评价 --> [*] : 结束

@enduml
```



# 04.3

```
@startuml
class User {
  +String username
  +String password
  +String email
  +List<Prescription> prescriptions
  +List<MedicalRecord> medicalRecords
  +makeAppointment()
  +consultDoctor()
  +viewPrescriptions()
  +viewMedicalRecords()
}

class Prescription {
  +String prescriptionID
  +Date date
  +String doctorName
  +String details
}

class MedicalRecord {
  +String recordID
  +Date date
  +String doctorName
  +String diagnosis
  +String treatment
}

User "1" -- "*" Prescription : has >
User "1" -- "*" MedicalRecord : has >
@enduml
```

```uml
@startuml
class AppointmentService {
  +List<Appointment> appointments
  +makeAppointment(User user, Doctor doctor, DateTime datetime)
  +cancelAppointment(Appointment appointment)
}

class Appointment {
  +DateTime datetime
  +Doctor doctor
  +User user
  +Status status
}

class Doctor {
  +String doctorID
  +String name
  +String specialty
  +List<Appointment> appointments
  +consult(User user)
}

class ConsultationService {
  +conductConsultation(Appointment appointment)
  +providePrescription()
  +provideMedicalRecord()
}

enum Status {
  Scheduled
  Cancelled
  Completed
}

AppointmentService "1" -- "*" Appointment
Appointment "*" -- "1" Doctor : consults >
Appointment "*" -- "1" User : booked by >
Doctor "1" -- "*" Appointment : has >
@enduml
```



```
@startuml
class EvaluationSystem {
  +List<Evaluation> evaluations
  +submitEvaluation(User user, Doctor doctor, String content, int rating)
  +viewEvaluations(Doctor doctor)
}

class Evaluation {
  +String evaluationID
  +User user
  +Doctor doctor
  +String content
  +int rating
  +DateTime datetime
}

class Doctor {
  +String doctorID
  +String name
  +String specialty
  +receiveEvaluation(Evaluation evaluation)
}

EvaluationSystem "1" -- "*" Evaluation : collects >
Evaluation "*" -- "1" Doctor : evaluated >
Evaluation "*" -- "1" User : submitted by >
@enduml

```

# 顶层数据流

```mermaid
flowchart TD
    subgraph registration ["User Registration and Login"]
        visitRegPage[("Visit Registration Page")]
        fillRegForm[("Fill Registration Form")]
        submitReg[("Submit Registration")]
        verifyRegInfo{{"Verify Registration Information"}}
        completeReg[("Complete Registration & Send Confirmation Email")]
        activateAccount[("Activate Account via Email Link")]
        login[("Login to Access Services")]
    end

    subgraph personalMedInfo ["Personal Medical Information Management"]
        viewMedInfo[("View Personal Medical Information")]
        updateMedInfo[("Update Medical Information")]
        authorizeAccess[("Authorize Access to Medical Information")]
        viewAccessRecords[("View Access Records")]
        systemPrompts[("Receive System Prompts and Health Tips")]
    end

    subgraph aiConsultation ["AI Medical Consultation Service"]
        submitSymptoms[("Submit Symptoms Description")]
        aiAnalysis[("AI Analysis of Condition")]
        getMedicalAdvice[("Receive Preliminary Medical Advice")]
        userFeedback[("User Feedback on Advice")]
        doctorReview[("Doctor Review if Needed")]
        trackFollowUp[("Track and Follow-up on Condition")]
    end

    subgraph departmentIntro ["Department and Specialization Introduction"]
        loginToSystem[("Login to System")]
        navigateDeptPage[("Navigate to Department Introduction Page")]
        selectDept[("Select Department of Interest")]
        viewDeptDetails[("View Department Details")]
        makeDeptChoice[("Make Department Choice")]
    end

    subgraph doctorAppointment ["Doctor Appointment Time Slot Selection"]
        viewDoctorList[("View Doctor List")]
        viewTimeSlots[("View Available Time Slots")]
        selectTimeSlot[("Select Appointment Time Slot")]
        confirmAppointmentDetails[("Confirm Appointment Details")]
        receiveConfirmation[("Receive Appointment Confirmation")]
        submitDoctorReview[("Submit Doctor Review Post-Appointment")]
    end

    subgraph doctorChoiceConfirm ["Doctor Selection and Appointment Confirmation"]
        viewDoctorProfiles[("View Doctor Profiles")]
        consultOnline[("Online Consultation with Doctors")]
        selectDoctor[("Select Doctor Based on Profiles")]
        selectAppointmentTimeSlot[("Select Time Slot for Appointment")]
        fillAppointmentInfo[("Fill in Appointment Information")]
        confirmDoctorAppointment[("Confirm Doctor Appointment")]
        trackAppointment[("Track Appointment Status")]
    end

    subgraph billing ["Medical Billing Management"]
        submitBilling[("Submit Medical Bills")]
        viewBilling[("View Billing Statement")]
        billingReview[("Medical Bill Review and Verification")]
        raiseBillingDisputes[("Raise Disputes on Billing Items")]
        receiveFinalBill[("Receive Finalized Billing Statement")]
        onlinePayment[("Online Payment of Medical Bills")]
    end

    subgraph paymentRefund ["Payment and Refund Process"]
        viewOutstandingFees[("View Outstanding Fees")]
        choosePaymentMethod[("Choose Payment Method")]
        paymentConfirmation[("Payment Confirmation")]
        viewRefundPolicy[("View Refund Policy")]
        applyForRefund[("Apply for Refund")]
        refundReview[("Review Refund Request")]
        processRefund[("Process Refund")]
        receiveRefundConfirmation[("Receive Refund Confirmation")]
    end

    login --> personalMedInfo
    login --> departmentIntro
    loginToSystem --> departmentIntro
    departmentIntro --> doctorAppointment
    departmentIntro --> doctorChoiceConfirm
    loginToSystem --> doctorChoiceConfirm
    confirmDoctorAppointment --> billing
    billing --> paymentRefund

    login --> aiConsultation
    aiConsultation --> doctorReview
    doctorReview --> doctorAppointment

    doctorAppointment --> submitDoctorReview
    doctorChoiceConfirm --> trackAppointment
    submitBilling --> viewBilling
    viewBilling --> billingReview
    billingReview --> raiseBillingDisputes
    raiseBillingDisputes --> billingReview
    billingReview --> onlinePayment
    onlinePayment --> paymentRefund
    viewOutstandingFees --> choosePaymentMethod
    choosePaymentMethod --> paymentConfirmation
    viewOutstandingFees --> viewRefundPolicy
    viewRefundPolicy --> applyForRefund
    applyForRefund --> refundReview
    refundReview --> processRefund
    processRefund --> receiveRefundConfirmation

```

```mermaid
graph TD
  A[访客] --> B[访客用户指令]
  B --> C[相应结果]
  C --> D[用户管理系统]
  E[病患] --> F[病患用户指令]
  F --> G[相应结果]
  G --> H[账单管理系统]
  I[医生] --> J[医生用户指令]
  J --> K[相应结果]
  K --> L[预约管理系统]
  M[管理员] --> N[管理员用户指令]
  N --> O[相应结果]
  O --> P[论坛评价系统]
  O --> Q[消息查询子系统]
  O --> R[AI增强子系统]
```

# 中层数据流图

```mermaid
flowchart TD
    subgraph reg ["User Registration and Authentication"]
        startReg[("Start Registration")]
        inputRegDetails[("Input Registration Details")]
        submitRegDetails[("Submit Registration Details")]
        validateRegDetails{{"Validate Details"}}
        regSuccess[("Registration Success")]
        sendConfirmation[("Send Confirmation Email")]
        confirmEmail[("Confirm Email")]
        regComplete[("Registration Complete")]

        userLogin[("User Login")]
        enterCredentials[("Enter Credentials")]
        validateLogin{{"Validate Login"}}
        loginSuccess[("Login Successful")]

        startReg --> inputRegDetails --> submitRegDetails --> validateRegDetails
        validateRegDetails -- "Valid" --> regSuccess --> sendConfirmation --> confirmEmail --> regComplete
        validateRegDetails -- "Invalid" --> startReg
        regComplete --> userLogin --> enterCredentials --> validateLogin
        validateLogin -- "Valid" --> loginSuccess
        validateLogin -- "Invalid" --> userLogin
    end

    subgraph personalInfo ["Personal Health Record Management"]
        accessRecords[("Access Health Records")]
        updateRecords[("Update Records")]
        submitUpdate[("Submit Update")]
        validateUpdate{{"Validate Update"}}
        updateSuccess[("Update Successful")]
        grantAccess[("Grant Access to Records")]
        reviewAccess[("Review Record Accesses")]

        accessRecords --> updateRecords --> submitUpdate --> validateUpdate
        validateUpdate -- "Valid" --> updateSuccess
        validateUpdate -- "Invalid" --> accessRecords
        updateSuccess --> grantAccess --> reviewAccess
    end

    subgraph aiConsult ["AI Assisted Consultation"]
        describeSymptoms[("Describe Symptoms")]
        aiProcessing[("AI Processing")]
        suggestActions[("Suggest Actions")]
        userInteract[("User Interaction with Suggestions")]
        requestDoctor[("Request Doctor Review")]
        aiLoopBack{{"Need More Data?"}}

        describeSymptoms --> aiProcessing --> suggestActions --> userInteract --> aiLoopBack
        aiLoopBack -- "Yes" --> describeSymptoms
        aiLoopBack -- "No" --> requestDoctor
    end

    subgraph appointment ["Appointment Management"]
        viewAvailability[("View Doctor's Availability")]
        chooseSlot[("Choose Time Slot")]
        inputPersonalInfo[("Input Personal Info for Appointment")]
        submitAppointment[("Submit Appointment Request")]
        confirmSlot[("Confirm Slot")]
        reminderSetup[("Setup Reminders")]
        postVisit[("Post Visit Actions")]

        viewAvailability --> chooseSlot --> inputPersonalInfo --> submitAppointment --> confirmSlot --> reminderSetup --> postVisit
    end

    subgraph billingMgmt ["Billing and Payment Management"]
        viewCharges[("View Charges")]
        itemizeCharges[("Itemize Charges")]
        submitPayment[("Submit Payment")]
        verifyPayment{{"Verify Payment"}}
        paymentConfirmed[("Payment Confirmed")]
        disputeCharge[("Dispute Charge")]
        resolveDispute[("Resolve Dispute")]

        viewCharges --> itemizeCharges --> submitPayment --> verifyPayment
        verifyPayment -- "Verified" --> paymentConfirmed
        verifyPayment -- "Discrepancy" --> disputeCharge --> resolveDispute --> viewCharges
    end

    subgraph refundProcess ["Refund Process"]
        requestRefund[("Request Refund")]
        reviewRefund[("Review Refund Request")]
        processRefundRequest[("Process Refund Request")]
        refundOutcome{{"Refund Approved?"}}
        issueRefund[("Issue Refund")]
        refundDenied[("Refund Denied")]

        requestRefund --> reviewRefund --> processRefundRequest --> refundOutcome
        refundOutcome -- "Yes" --> issueRefund
        refundOutcome -- "No" --> refundDenied
    end

    loginSuccess --> personalInfo
    loginSuccess --> aiConsult
    loginSuccess --> appointment
    paymentConfirmed --> refundProcess

    style reg fill:#f9f,stroke:#333,stroke-width:2px
    style personalInfo fill:#bbf,stroke:#333,stroke-width:2px
    style aiConsult fill:#fbf,stroke:#333,stroke-width:2px
    style appointment fill:#bfb,stroke:#333,stroke-width:2px
    style billingMgmt fill:#ffd,stroke:#333,stroke-width:2px
    style refundProcess fill:#ddf,stroke:#333,stroke-width:2px

```

```mermaid
flowchart LR
    patient("病人") -->|提交咨询| consultation[("咨询")]
    consultation -->|生成病历| medicalRecord[("生成病历")]
    medicalRecord --> pastTests[("Pastiest 结果的医疗记录")]
    medicalRecord -->|查询病历| doctor[("医生")]
    doctor -->|查看病历| reviewRecords[("查看病历")]
    reviewRecords -->|诊断| diagnosis[("诊断")]
    diagnosis -->|开具药方| prescription[("开具药方")]
    diagnosis -->|建议检查| suggestTests[("建议检查")]
    suggestTests --> patient
    prescription --> patient
    
    patient -->|填写反馈| feedback[("填写反馈")]
    feedback -->|更新病历| medicalRecord
    feedback --> doctor

    subgraph hospitalSystem["医院系统"]
        consultation
        medicalRecord
        reviewRecords
        diagnosis
        prescription
        suggestTests
        feedback
    end

    style hospitalSystem fill:#FFF,stroke:#AAA,stroke-width:2px,stroke-dasharray: 5 5

```



```mermaid
graph TD
    A[WelcomePage] --> |"/"| B[Welcome]
    A --> |"/patient"| C[PatientPage]
    A --> |"/doctor"| D[DoctorPage]
    A --> |"/admin"| E[AdminPage]

    subgraph PatientRoutes
        C --> |"appointment"| F[AppointmentPage]
        C --> |"profile"| G[ProfilePage]
        C --> |"settings"| H[SettingsPage]
        C --> |"medical-record"| I[MedicalRecordPage]
        C --> |"comment"| J[CommentPage]
        C --> |"payment"| K[PaymentPage]
        C --> |"message"| L[MessagePage]
    end

    classDef requiresAuth fill:#f96,stroke:#333,stroke-width:2px;
    D:::requiresAuth
    E:::requiresAuth
    G:::requiresAuth
    H:::requiresAuth
    K:::requiresAuth

    classDef default fill:#bbf,stroke:#333,stroke-width:2px;
    A:::default
    B:::default
    C:::default
    F:::default
    I:::default
    J:::default
    L:::default

```

