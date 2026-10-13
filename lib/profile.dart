class Role {
  const Role({
    required this.span,
    required this.org,
    required this.title,
    required this.lines,
    required this.tools,
  });

  final String span;
  final String org;
  final String title;
  final List<String> lines;
  final List<String> tools;
}

class Study {
  const Study({required this.span, required this.school, required this.detail});

  final String span;
  final String school;
  final String detail;
}

class Work {
  const Work({required this.name, required this.detail, required this.link});

  final String name;
  final String detail;
  final String link;
}

class Mark {
  const Mark({required this.title, required this.detail});

  final String title;
  final String detail;
}

class Spoken {
  const Spoken(this.name, this.level);

  final String name;
  final String level;
}

class Profile {
  const Profile({
    required this.name,
    required this.blurb,
    required this.roles,
    required this.studies,
    required this.stack,
    required this.works,
    required this.marks,
    required this.spoken,
    required this.links,
  });

  final String name;
  final List<String> blurb;
  final List<Role> roles;
  final List<Study> studies;
  final List<String> stack;
  final List<Work> works;
  final List<Mark> marks;
  final List<Spoken> spoken;
  final List<String> links;
}

const profile = Profile(
  name: 'Alghisi Alessandro Paolo',
  blurb: [
    'Senior full stack engineer. React, TypeScript, Node.js, Python, C++.',
    'Two internships at Google. Bronze, twice, at the national informatics olympiad.',
    'I have spent the last decade on products people actually hit: classifieds',
    'at millions of monthly users, a PDF gesture in Chrome, compliance software,',
    'video rooms with a shared editor.',
  ],
  roles: [
    Role(
      span: '2026',
      org: 'Raw Geeks',
      title: 'Senior full stack, Cluj',
      lines: [
        'Lead features on React, TypeScript and Node.',
        'LLM assistants in the product: streaming, tool calling, structured JSON.',
        'RAG on pgvector and Pinecone, plus a prompt-evaluation harness.',
      ],
      tools: ['React', 'TypeScript', 'Node.js', 'pgvector', 'Pinecone'],
    ),
    Role(
      span: '2025',
      org: 'Complaion',
      title: 'Senior full stack, Milan',
      lines: [
        'FastAPI services and a React + TypeScript client for ISO compliance.',
        'Document understanding with strict JSON schemas and a person in the loop.',
        'Agentic lookup for compliance officers.',
        'OneDrive, SharePoint and Google Drive, with a real sync.',
      ],
      tools: ['Python', 'FastAPI', 'React', 'TypeScript', 'JSON Schema'],
    ),
    Role(
      span: '2024–2025',
      org: 'Independent',
      title: 'Senior video and full stack, contract',
      lines: [
        'Collab: a Zoom-like room in React, React Native (Expo) and WebRTC.',
        'Shared Monaco document, a colour per person, Run for five languages.',
        'Zoom Video SDK and Webex Embedded Apps, weighed for a client.',
        'RAG pipelines and AEM (HTL, Sling, OSGi, Cloud Service).',
      ],
      tools: ['React', 'React Native', 'WebRTC', 'TypeScript', 'AEM'],
    ),
    Role(
      span: '2017–2024',
      org: 'Sector Labs',
      title: 'Full stack, Cluj',
      lines: [
        'Bayut, Zameen and other classifieds, from the ground up.',
        'Millions of monthly users. A small senior team.',
        'React, Redux, TypeScript on the front. Redis on the hot paths.',
        'Django and Node on the back. Concept to production with design.',
      ],
      tools: ['React', 'Redux', 'TypeScript', 'Django', 'Redis'],
    ),
    Role(
      span: '2017',
      org: 'Hewlett Packard Enterprise',
      title: 'Senior software engineer, LoadRunner',
      lines: [
        'Web-protocol engine in C++ / VuGen. Replay reliability.',
        'Cookies, headers, session correlation. Wireshark on the hard ones.',
        'About a quarter more efficiency on the paths I touched.',
      ],
      tools: ['C++', 'LoadRunner', 'Wireshark', 'HTTP'],
    ),
    Role(
      span: '2016',
      org: 'Google',
      title: 'Software engineer intern, Mountain View',
      lines: [
        'Logging prototype. About 15% better data processing on that path.',
        'A C++ tool that scores whether a policy is safe to release.',
        'Python beside it. Big data, release framework, rule ratios.',
      ],
      tools: ['C++', 'Python', 'Big data'],
    ),
    Role(
      span: '2016',
      org: 'Google Chrome',
      title: 'Software engineer intern, Kitchener',
      lines: [
        'Pinch-to-zoom in Chrome\'s PDF viewer. Shipped through Chromium review.',
        'Touch, gesture, and the algebra that keeps the point under the fingers still.',
        'Landed across 19 files: renderer IPC, PPAPI, the public API, tests.',
      ],
      tools: ['C++', 'JavaScript', 'Chromium'],
    ),
    Role(
      span: '2015',
      org: 'Algotech Solutions',
      title: 'Software developer, Cluj',
      lines: [
        'First production React and Node, in a short-cycle studio.',
        'REST, jQuery, and the habit of shipping the ugly middle of a feature.',
      ],
      tools: ['React', 'Node.js', 'jQuery'],
    ),
    Role(
      span: '2015',
      org: 'Yardi Systems',
      title: 'Software engineer intern, Cluj',
      lines: [
        'Real-estate data tooling. First look at property systems at scale.',
      ],
      tools: ['Web', 'Property data'],
    ),
  ],
  studies: [
    Study(
      span: '2014–2017',
      school: 'Babes-Bolyai University',
      detail: 'Bachelor, Computer Science. Algorithms, data structures, software engineering.',
    ),
    Study(
      span: '2020–2022',
      school: 'Technical University of Cluj-Napoca',
      detail: 'Master. Software architecture, distributed systems, project management. Done while working.',
    ),
  ],
  stack: [
    'Frontend     React, TypeScript, Redux, Next.js, React Native (Expo), HTML, CSS',
    'Backend      Node.js, Python, FastAPI, Django, REST',
    'Data         PostgreSQL, Redis, pgvector, Pinecone',
    'Systems      C++, Chromium, LoadRunner, Wireshark, HTTP replay',
    'Product      streaming tool calls, RAG, JSON schemas, prompt evaluation',
    'Delivery     Git, CI, OAuth 2.0, JWT, webhooks, WebRTC, AEM',
  ],
  works: [
    Work(
      name: 'Collab',
      detail: 'Video room plus a shared Monaco document. Run compiles JS, TS, Python, Go or C++.',
      link: 'github.com/alexalghisi/collab',
    ),
    Work(
      name: 'Chrome PDF pinch-to-zoom',
      detail: 'The point under the fingers stays put. Public Chromium review 1881603002.',
      link: 'codereview.chromium.org/1881603002',
    ),
    Work(
      name: 'A11yDojo',
      detail: 'WCAG drills for missing names, bad heading order, and focus that escapes a dialog.',
      link: 'github.com/alexalghisi/A11yDojo',
    ),
    Work(
      name: 'AgentTower',
      detail:
          'Traces, token burn and cost for agent runs. A timeline per step.',
      link: 'github.com/alexalghisi/agenttower',
    ),
    Work(
      name: 'PDF editor',
      detail: 'A React Native editor that rewrites the content stream. Text and images stay nodes.',
      link: 'github.com/alexalghisi/pdf-editor',
    ),
    Work(
      name: 'Dual-pane explorer',
      detail: 'Finder-like drag and drop. Required files cannot leave their folder. Keyboard parity.',
      link: 'github.com/alexalghisi/react-modern-drag-and-drop',
    ),
  ],
  marks: [
    Mark(
      title: 'Bronze, Romanian National Informatics Olympiad',
      detail: '2013 and 2014. Also 10/10 in Informatics on the baccalaureate.',
    ),
  ],
  spoken: [
    Spoken('Romanian', 'native'),
    Spoken('Italian', 'native'),
    Spoken('English', 'full professional'),
    Spoken('Spanish', 'professional working'),
    Spoken('Russian', 'elementary'),
  ],
  links: [
    'LinkedIn   linkedin.com/in/alghisi',
    'GitHub     github.com/alexalghisi',
    'City       Cluj-Napoca',
  ],
);
