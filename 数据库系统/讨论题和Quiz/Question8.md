>举一个复杂数据类型应用的例子，说明其中除关系之外存在的复杂数据类型

以企业员工信息管理系统作为复杂数据类型应用为例，说明其中除关系之外存在的复杂数据类型



比如，互联网企业员工信息管理系统，需要存储有关员工技能和项目经验的信息。为了表示此数据，系统可能会使用数组。

例如，系统可能有一个名为“employee_skills”的数组，用于存储每个员工的技能列表。

数组中的每个元素都代表一项特定技能，元素的值将指示员工对该技能的熟练程度。

因此，对于员工 A，“employee_skills”数组可能如下所示：

```sql
employee_skills = {
    "A": {
        "Python": 3, 
        "Java": 4, 
        "SQL": 5,
        "C#":4
    }
}
```

employee_projects”的数组，用于存储每个员工所从事的项目列表。数组中的每个元素都代表一个特定的项目，元素的值将提供详细信息，例如项目名称、工作日期以及员工在项目中的角色

```sql
employee_projects = {
    "A": [
        {
            "project_name": "Sales Dashboard",
            "start_date": "2022-01-01",
            "end_date": "2022-12-31",
            "role": "Developer"
        },
        {
            "project_name": "Customer Segmentation",
            "start_date": "2023-01-01",
            "end_date": "2023-12-01",
            "role": "CTO"
        }
    ]
}
```

