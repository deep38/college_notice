import 'package:college_notice/data/models/staff.dart';
import 'package:college_notice/data/models/student.dart';

String noticeJson = '''[{"title": "Campus Closure: Inclement Weather",
    "date": "2023-05-17",
    "content": "Due to severe weather conditions, the college campus will remain closed on May 18th. All classes, exams, and events scheduled for that day are canceled. Please stay safe and follow local weather advisories. Regular operations will resume once the weather improves."
  },
  {
    "title": "Guest Lecture: Career Opportunities in IT",
    "date": "2023-05-20",
    "content": "We are pleased to announce a guest lecture on 'Career Opportunities in the IT Industry' scheduled for May 25th, from 2:00 PM to 4:00 PM in the auditorium. The lecture will be delivered by Mr. John Smith, an industry expert with over 10 years of experience. All interested students are encouraged to attend."
  },
  {
    "title": "Library Closure: Renovation Work",
    "date": "2023-05-22",
    "content": "The college library will be closed for renovation from May 25th to June 10th. During this period, students can avail of library services at the temporary library setup in the Student Center. We apologize for any inconvenience caused."
  },
  {
    "title": "Sports Day Announcement",
    "date": "2023-05-24",
    "content": "We are excited to announce the annual Sports Day event, which will take place on June 5th. Various sports competitions and fun activities have been planned. Interested students can sign up at the Sports Office before May 30th. Let's make this Sports Day a memorable one!"
  },
  {
    "title": "Career Counseling Session",
    "date": "2023-05-28",
    "content": "A career counseling session will be held on June 2nd, from 10:00 AM to 12:00 PM in the Seminar Hall. Career experts will provide guidance on choosing the right career path and answer your queries. All students are encouraged to attend this informative session."
  },
  {
    "title": "Scholarship Application Deadline Extension",
    "date": "2023-06-01",
    "content": "The deadline for submitting scholarship applications has been extended to June 10th. Eligible students who have not yet applied are encouraged to take advantage of this opportunity. Don't miss out on the chance to secure financial assistance for your education."
  },
  {
    "title": "Volunteer Opportunity: Community Service Program",
    "date": "2023-06-05",
    "content": "We are organizing a community service program on June 10th, where students can contribute to various social initiatives. If you are interested in volunteering, please register at the Student Affairs Office before June 8th. Let's come together to make a positive impact!"
  },
  {
    "title": "Course Registration Reminder",
    "date": "2023-06-08",
    "content": "This is a friendly reminder that the course registration for the upcoming semester will begin on June 15th. Please review the course catalog and consult with your academic advisor to plan your course schedule. Be prepared to register for your preferred courses during the allotted time."
  },
  {
    "title": "Internship Opportunity: Marketing Department",
    "date": "2023-06-12",
    "content": "We have an exciting internship opportunity available in the Marketing Department. Interested students in their penultimate year can apply by submitting their resumes and cover letters to the Career Services Office by June 20th. Don't miss the chance to gain valuable industry experience."
  },
  {
    "title": "Workshop: Effective Time Management",
    "date": "2023-06-15",
    "content": "A workshop on 'Effective Time Management' will be conducted on June 22nd, from 3:00 PM to 5:00 PM in Room 202. Learn valuable techniques to optimize your time, improve productivity, and achieve a better work-life balance. All students are welcome to attend."
  }
]''';

List<String> colleges = ["L. D. college of engineering", "L. M. college of engineering"];
List<String> departments = ["Information technology", "Computer science"];
List<Staff> faculty = [
  // Faculty(
  //     name: "John Smith",
  //     email: "john.smith@example.com",
  //     phone: "(123) 456-7890",
  //   ),
  //   Faculty(
  //     name: "Emily Johnson",
  //     email: "emily.johnson@example.com",
  //     phone: "(234) 567-8901",
  //   ),
  //   Faculty(
  //     name: "David Wilson",
  //     email: "david.wilson@example.com",
  //     phone: "(345) 678-9012",
  //   ),
  //   Faculty(
  //     name: "Sarah Davis",
  //     email: "sarah.davis@example.com",
  //     phone: "(456) 789-0123",
  //   ),
  //   Faculty(
  //     name: "Michael Thompson",
  //     email: "michael.thompson@example.com",
  //     phone: "(567) 890-1234",
  //   ),
  //   Faculty(
  //     name: "Jessica Anderson",
  //     email: "jessica.anderson@example.com",
  //     phone: "(678) 901-2345",
  //   ),
  //   Faculty(
  //     name: "Daniel Martinez",
  //     email: "daniel.martinez@example.com",
  //     phone: "(789) 012-3456",
  //   ),
  //   Faculty(
  //     name: "Olivia Taylor",
  //     email: "olivia.taylor@example.com",
  //     phone: "(890) 123-4567",
  //   ),
  //   Faculty(
  //     name: "Christopher Brown",
  //     email: "christopher.brown@example.com",
  //     phone: "(901) 234-5678",
  //   ),
  //   Faculty(
  //     name: "Ava Miller",
  //     email: "ava.miller@example.com",
  //     phone: "(012) 345-6789",
  //   ),
];

  List<Student> students = [
    // Student(
    //   enrollment: "2021001",
    //   name: "Amit Kumar",
    //   email: "amit.kumar@example.com",
    //   phone: "+91 1234567890",
    // ),
    // Student(
    //   enrollment: "2021002",
    //   name: "Priya Patel",
    //   email: "priya.patel@example.com",
    //   phone: "+91 2345678901",
    // ),
    // Student(
    //   enrollment: "2021003",
    //   name: "Rahul Sharma",
    //   email: "rahul.sharma@example.com",
    //   phone: "+91 3456789012",
    // ),
    // Student(
    //   enrollment: "2021004",
    //   name: "Ananya Gupta",
    //   email: "ananya.gupta@example.com",
    //   phone: "+91 4567890123",
    // ),
    // Student(
    //   enrollment: "2021005",
    //   name: "Vikram Singh",
    //   email: "vikram.singh@example.com",
    //   phone: "+91 5678901234",
    // ),
    // Student(
    //   enrollment: "2021006",
    //   name: "Shreya Mehta",
    //   email: "shreya.mehta@example.com",
    //   phone: "+91 6789012345",
    // ),
    // Student(
    //   enrollment: "2021007",
    //   name: "Rajesh Tiwari",
    //   email: "rajesh.tiwari@example.com",
    //   phone: "+91 7890123456",
    // ),
    // Student(
    //   enrollment: "2021008",
    //   name: "Neha Verma",
    //   email: "neha.verma@example.com",
    //   phone: "+91 8901234567",
    // ),
    // Student(
    //   enrollment: "2021009",
    //   name: "Sandeep Malik",
    //   email: "sandeep.malik@example.com",
    //   phone: "+91 9012345678",
    // ),
    // Student(
    //   enrollment: "2021010",
    //   name: "Divya Joshi",
    //   email: "divya.joshi@example.com",
    //   phone: "+91 0123456789",
    // ),
  ];