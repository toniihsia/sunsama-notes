### Approach to Task 5
This form of indexing is called compound indexing. The index will contain references to documents sorted first by tasks that are `completed` and, within each value of the completed field, sorted by values of the `completedDate` field.

In other words, you will be indexing and sorting by `completed` before `completeDate`. This is important because only `completed` tasks will have a `completeDate`.
