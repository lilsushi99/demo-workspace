import fs from 'fs';
import path from 'path';
import bcrypt from 'bcryptjs';

const ADMIN_PASSWORD_HASH = bcrypt.hashSync('Admin@123', 10);

export function generateDemoSql(): string {
  // 1. Staff Members (Exactly 4)
  const staff = [
    {
      id: 'USR-001',
      name: 'Dominion Adebayo',
      email: 'admin@gmail.com',
      phone: '+234 803 200 1101',
      role: 'Director',
      branch: 'All Branches',
      branchId: 'BR-001',
      empId: 'EMP-001',
      dept: 'Executive',
      pos: 'Director',
      salary: 850000,
    },
    {
      id: 'USR-002',
      name: 'Chioma Okonkwo',
      email: 'chioma.okonkwo@workspace.ng',
      phone: '+234 802 334 5566',
      role: 'Manager',
      branch: 'Hive Hub',
      branchId: 'BR-001',
      empId: 'EMP-002',
      dept: 'Operations',
      pos: 'Manager',
      salary: 450000,
    },
    {
      id: 'USR-003',
      name: 'Amara Nwosu',
      email: 'amara.nwosu@workspace.ng',
      phone: '+234 814 556 7788',
      role: 'Receptionist', // Mapped to Front Desk in UI & Position
      branch: 'Art and Tech Hub',
      branchId: 'BR-002',
      empId: 'EMP-003',
      dept: 'Front Desk',
      pos: 'Front Desk',
      salary: 220000,
    },
    {
      id: 'USR-004',
      name: 'Ibrahim Danjuma',
      email: 'ibrahim.danjuma@workspace.ng',
      phone: '+234 809 667 8899',
      role: 'Accountant',
      branch: 'All Branches',
      branchId: 'BR-001',
      empId: 'EMP-004',
      dept: 'Finance',
      pos: 'Accountant',
      salary: 400000,
    },
  ];

  // 2. Branches (Exactly 2)
  const branches = [
    {
      id: 'BR-001',
      code: 'HVH',
      name: 'Hive Hub',
      location: 'Plot 14 Admiralty Way, Lekki Phase 1, Lagos',
      state: 'Lagos',
      status: 'Active',
      createdDate: '2025-01-15',
    },
    {
      id: 'BR-002',
      code: 'ATH',
      name: 'Art and Tech Hub',
      location: '24 Commercial Avenue, Sabo, Yaba, Lagos',
      state: 'Lagos',
      status: 'Active',
      createdDate: '2025-02-01',
    },
  ];

  // 3. Facilities (4 per branch = 8 total)
  const facilities = [
    {
      id: 'FAC-001',
      name: 'Hot Desk Zone',
      branchId: 'BR-001',
      branchName: 'Hive Hub',
      price: 5000,
      capacity: 25,
      desc: 'Open-plan ergonomic flex desks with dedicated high-speed Starlink broadband and power backup.',
    },
    {
      id: 'FAC-002',
      name: 'Dedicated Workstation',
      branchId: 'BR-001',
      branchName: 'Hive Hub',
      price: 12500,
      capacity: 12,
      desc: 'Permanent reserved desk with lockable storage pedestal in a quiet productivity zone.',
    },
    {
      id: 'FAC-003',
      name: 'Executive Private Suite',
      branchId: 'BR-001',
      branchName: 'Hive Hub',
      price: 45000,
      capacity: 4,
      desc: 'Enclosed soundproofed 4-person executive office suite with biometric door access.',
    },
    {
      id: 'FAC-004',
      name: 'Collaborative Meeting Room',
      branchId: 'BR-001',
      branchName: 'Hive Hub',
      price: 20000,
      capacity: 8,
      desc: '8-seater presentation conference room equipped with 4K display and smart video soundbar.',
    },
    {
      id: 'FAC-005',
      name: 'Creative Open Desk',
      branchId: 'BR-002',
      branchName: 'Art and Tech Hub',
      price: 4500,
      capacity: 30,
      desc: 'Vibrant shared workstations with natural lighting and direct cafe breakout space.',
    },
    {
      id: 'FAC-006',
      name: 'Private Studio Office',
      branchId: 'BR-002',
      branchName: 'Art and Tech Hub',
      price: 40000,
      capacity: 6,
      desc: 'Furnished 6-person studio suite tailored for digital agencies and tech development pods.',
    },
    {
      id: 'FAC-007',
      name: 'Podcast & Audio Lab',
      branchId: 'BR-002',
      branchName: 'Art and Tech Hub',
      price: 25000,
      capacity: 3,
      desc: 'Acoustically isolated broadcast booth with Shure SM7B mics and Rodecaster Pro console.',
    },
    {
      id: 'FAC-008',
      name: 'Tech Conference Hall',
      branchId: 'BR-002',
      branchName: 'Art and Tech Hub',
      price: 60000,
      capacity: 15,
      desc: 'Multi-purpose 15-seater conference hall with laser projector, wireless mics, and PA system.',
    },
  ];

  // 4. Expense Categories (Exactly 5 one-word categories)
  const categories = [
    {
      id: 'CAT-001',
      ref: 'EC-001',
      name: 'Utilities',
      color: '#3B82F6',
      desc: 'Starlink subscription, MTN internet subscription, water supply, and recurring utility bills.',
    },
    {
      id: 'CAT-002',
      ref: 'EC-002',
      name: 'Hygiene',
      color: '#10B981',
      desc: 'Toilet rolls, toiletries, air fresheners, fragrance diffusers, and cleaning-related consumables.',
    },
    {
      id: 'CAT-003',
      ref: 'EC-003',
      name: 'Equipment',
      color: '#8B5CF6',
      desc: 'Extension sockets, power strips, and other small workspace equipment used to power laptops and devices.',
    },
    {
      id: 'CAT-004',
      ref: 'EC-004',
      name: 'Maintenance',
      color: '#F59E0B',
      desc: 'AC servicing and repairs, electrical repairs, socket repairs, plumbing, and general facility maintenance.',
    },
    {
      id: 'CAT-005',
      ref: 'EC-005',
      name: 'Marketing',
      color: '#EC4899',
      desc: 'Banner printing, promotional materials, advertising, and workspace publicity.',
    },
  ];

  // 5. Customers (Exactly 33 Unique Nigerian Customers)
  const customers = [
    { id: 'CL-001', ref: 'CL-REF-001', name: 'Babatunde Adeyemi', phone: '+234 803 111 2233', email: 'babatunde.adeyemi@paystackalumni.ng', company: 'Paystack Alumni Ventures', status: 'VIP' },
    { id: 'CL-002', ref: 'CL-REF-002', name: 'Chioma Okoli', phone: '+234 802 222 3344', email: 'chioma.okoli@koracreative.ng', company: 'Kora Creative Studios', status: 'Active' },
    { id: 'CL-003', ref: 'CL-REF-003', name: 'Olumide Bakare', phone: '+234 814 333 4455', email: 'olumide.bakare@venturesplatform.ng', company: 'Ventures Platform Capital', status: 'VIP' },
    { id: 'CL-004', ref: 'CL-REF-004', name: 'Amina Ibrahim', phone: '+234 809 444 5566', email: 'amina.ibrahim@savannahagri.ng', company: 'Savannah AgriTech Solutions', status: 'Active' },
    { id: 'CL-005', ref: 'CL-REF-005', name: 'Chukwuemeka Eze', phone: '+234 805 555 6677', email: 'c.eze@monopartners.ng', company: 'Mono Finance Partners', status: 'VIP' },
    { id: 'CL-006', ref: 'CL-REF-006', name: 'Folake Adeleke', phone: '+234 818 666 7788', email: 'folake.adeleke@brass-studio.africa', company: 'Brass Studio Africa', status: 'Active' },
    { id: 'CL-007', ref: 'CL-REF-007', name: 'Temitope Ogunleye', phone: '+234 807 777 8899', email: 'temitope.ogunleye@designguild.ng', company: 'Flutterwave Design Guild', status: 'Active' },
    { id: 'CL-008', ref: 'CL-REF-008', name: 'Zainab Bello', phone: '+234 811 888 9900', email: 'zainab.bello@wealthlabs.ng', company: 'Piggyvest Wealth Labs', status: 'VIP' },
    { id: 'CL-009', ref: 'CL-REF-009', name: 'Ifeanyi Nwosu', phone: '+234 813 999 0011', email: 'ifeanyi.nwosu@risevestlabs.ng', company: 'Risevest Engineering Hub', status: 'Active' },
    { id: 'CL-010', ref: 'CL-REF-010', name: 'Ngozi Adeleke', phone: '+234 816 111 0022', email: 'ngozi.adeleke@zikokomedia.ng', company: 'Zikoko Digital Media', status: 'Active' },
    { id: 'CL-011', ref: 'CL-REF-011', name: 'Dapo Osinowo', phone: '+234 802 345 6789', email: 'dapo.osinowo@edenlifeops.ng', company: 'Eden Life Operations', status: 'Active' },
    { id: 'CL-012', ref: 'CL-REF-012', name: 'Halima Danjuma', phone: '+234 803 456 7890', email: 'halima.danjuma@heliumrecords.ng', company: 'Helium Health Records', status: 'VIP' },
    { id: 'CL-013', ref: 'CL-REF-013', name: 'Kelechi Onyekwelu', phone: '+234 805 567 8901', email: 'kelechi@cowrywisegrowth.ng', company: 'Cowrywise Growth Agency', status: 'Active' },
    { id: 'CL-014', ref: 'CL-REF-014', name: 'Simisola Fashola', phone: '+234 807 678 9012', email: 'simisola.fashola@altschoolafrica.ng', company: 'AltSchool Africa Fellows', status: 'Active' },
    { id: 'CL-015', ref: 'CL-REF-015', name: 'Obinna Nnamani', phone: '+234 809 789 0123', email: 'obinna.nnamani@reliancehealth.ng', company: 'Reliance Health Consult', status: 'VIP' },
    { id: 'CL-016', ref: 'CL-REF-016', name: 'Aisha Mohammed', phone: '+234 810 890 1234', email: 'aisha.mohammed@stearsdata.ng', company: 'Stears Intelligence', status: 'Active' },
    { id: 'CL-017', ref: 'CL-REF-017', name: 'Femi Balogun', phone: '+234 812 901 2345', email: 'femi.balogun@techcabal.ng', company: 'TechCabal Editorial', status: 'Active' },
    { id: 'CL-018', ref: 'CL-REF-018', name: 'Blessing Jumbo', phone: '+234 814 012 3456', email: 'blessing.jumbo@investbamboo.ng', company: 'Bamboo Investment Partners', status: 'VIP' },
    { id: 'CL-019', ref: 'CL-REF-019', name: 'Tobi Alabi', phone: '+234 816 123 4567', email: 'tobi.alabi@nombaservices.ng', company: 'Nomba Merchant Services', status: 'Active' },
    { id: 'CL-020', ref: 'CL-REF-020', name: 'Mariam Abubakar', phone: '+234 818 234 5678', email: 'mariam.abubakar@seamlesshr.ng', company: 'SeamlessHR People Advisory', status: 'Active' },
    { id: 'CL-021', ref: 'CL-REF-021', name: 'Chinedu Obi', phone: '+234 803 345 6781', email: 'chinedu.obi@tradedepot.ng', company: 'TradeDepot Supply Chain', status: 'Active' },
    { id: 'CL-022', ref: 'CL-REF-022', name: 'Ronke Awolowo', phone: '+234 802 456 7892', email: 'ronke.awolowo@kudastrategy.ng', company: 'Kuda Banking Strategy', status: 'Active' },
    { id: 'CL-023', ref: 'CL-REF-023', name: 'Uche Okoye', phone: '+234 805 567 8903', email: 'uche.okoye@autochek.ng', company: 'Autochek Mobility Ventures', status: 'Active' },
    { id: 'CL-024', ref: 'CL-REF-024', name: 'Fatima Sanusi', phone: '+234 807 678 9014', email: 'fatima.sanusi@termiisolutions.ng', company: 'Termii Telecom Solutions', status: 'Active' },
    { id: 'CL-025', ref: 'CL-REF-025', name: 'Kunle Ajayi', phone: '+234 809 789 0125', email: 'kunle.ajayi@moniepointnetwork.ng', company: 'TeamApt Moniepoint Network', status: 'VIP' },
    { id: 'CL-026', ref: 'CL-REF-026', name: 'Efe Omoworare', phone: '+234 810 890 1236', email: 'efe.omoworare@patriciabrand.ng', company: 'Patricia Brand Strategy', status: 'Active' },
    { id: 'CL-027', ref: 'CL-REF-027', name: 'Hadiza Aliyu', phone: '+234 812 901 2347', email: 'hadiza.aliyu@vendeasefoods.ng', company: 'Vendease Food Procurement', status: 'Active' },
    { id: 'CL-028', ref: 'CL-REF-028', name: 'Nonso Madu', phone: '+234 814 012 3458', email: 'nonso.madu@lemfiremit.ng', company: 'LemFi Diaspora Remittance', status: 'Active' },
    { id: 'CL-029', ref: 'CL-REF-029', name: 'Yetunde Oladipo', phone: '+234 816 123 4569', email: 'yetunde.oladipo@moovefleet.ng', company: 'Moove Global Fleet', status: 'Active' },
    { id: 'CL-030', ref: 'CL-REF-030', name: 'Tariro Akindele', phone: '+234 818 234 5670', email: 'tariro.akindele@chowdeckfleet.ng', company: 'Chowdeck Logistics Fleet', status: 'Active' },
    { id: 'CL-031', ref: 'CL-REF-031', name: 'Osas Ighodaro', phone: '+234 803 345 6782', email: 'osas.ighodaro@getanchor.ng', company: 'Anchor Banking Infrastructure', status: 'Expiring Soon' },
    { id: 'CL-032', ref: 'CL-REF-032', name: 'Nkechi Nwankwo', phone: '+234 802 456 7893', email: 'nkechi.nwankwo@remedialhealth.ng', company: 'Remedial Health Logistics', status: 'Expired' },
    { id: 'CL-033', ref: 'CL-REF-033', name: 'Yusuf Garba', phone: '+234 805 567 8904', email: 'yusuf.garba@sabidistribution.ng', company: 'Sabi B2B Distribution', status: 'Active' },
  ];

  // 6. Bookings (Exactly 104 Bookings)
  // Spread across May 2026 to November 2026.
  // Today's date context: October 27, 2026.
  interface BookingSpec {
    idx: number;
    custIdx: number; // 0 to 32
    facIdx: number;  // 0 to 7
    date: string;
    daysCount: number;
    amount: number;
    paymentMethod: string;
    status: 'Active' | 'Expired' | 'Upcoming' | 'Cancelled';
    daysUsed: number;
    daysLeft: number;
    timeDuration: string;
  }

  const bookingSpecs: BookingSpec[] = [];

  // Helper date generators
  const dates = [
    // May 2026 (8 bookings)
    '2026-05-04', '2026-05-08', '2026-05-12', '2026-05-15', '2026-05-19', '2026-05-22', '2026-05-26', '2026-05-29',
    // June 2026 (10 bookings)
    '2026-06-02', '2026-06-05', '2026-06-08', '2026-06-11', '2026-06-15', '2026-06-18', '2026-06-22', '2026-06-25', '2026-06-29', '2026-06-30',
    // July 2026 (12 bookings)
    '2026-07-02', '2026-07-06', '2026-07-09', '2026-07-13', '2026-07-16', '2026-07-20', '2026-07-23', '2026-07-27', '2026-07-28', '2026-07-29', '2026-07-30', '2026-07-31',
    // August 2026 (15 bookings)
    '2026-08-03', '2026-08-05', '2026-08-07', '2026-08-10', '2026-08-12', '2026-08-14', '2026-08-17', '2026-08-19', '2026-08-21', '2026-08-24', '2026-08-26', '2026-08-27', '2026-08-28', '2026-08-29', '2026-08-31',
    // September 2026 (18 bookings)
    '2026-09-01', '2026-09-03', '2026-09-07', '2026-09-09', '2026-09-11', '2026-09-14', '2026-09-16', '2026-09-18', '2026-09-21', '2026-09-22', '2026-09-23', '2026-09-24', '2026-09-25', '2026-09-28', '2026-09-29', '2026-09-30', '2026-09-30', '2026-09-30',
    // October 2026 (33 bookings, including this week & today Oct 27)
    '2026-10-01', '2026-10-02', '2026-10-05', '2026-10-06', '2026-10-07', '2026-10-08', '2026-10-09', '2026-10-12', '2026-10-13', '2026-10-14',
    '2026-10-15', '2026-10-16', '2026-10-19', '2026-10-20', '2026-10-21', '2026-10-21', '2026-10-22', '2026-10-22', '2026-10-23', '2026-10-23',
    '2026-10-24', '2026-10-24', '2026-10-25', '2026-10-26', '2026-10-26', '2026-10-26', '2026-10-27', '2026-10-27', '2026-10-27', '2026-10-27',
    '2026-10-27', '2026-10-27', '2026-10-27',
    // Upcoming: late October & November 2026 (8 bookings)
    '2026-10-28', '2026-10-29', '2026-10-30', '2026-11-02', '2026-11-03', '2026-11-05', '2026-11-09', '2026-11-12',
  ];

  const payMethods = ['Wire Transfer', 'POS Terminal', 'Cash', 'Credit Card', 'Corporate Billing'];
  const durations = ['09:00 AM - 05:00 PM', '08:00 AM - 06:00 PM', '10:00 AM - 04:00 PM', '09:00 AM - 01:00 PM', '01:00 PM - 06:00 PM'];

  // Explicit cancelled indices: exactly 4 cancelled bookings (spread across May, July, Sep, Oct)
  const cancelledIndices = [17, 36, 61, 88];

  for (let i = 0; i < 104; i++) {
    const custIdx = i % 33; // Guarantees all 33 customers have bookings!
    const facIdx = i % 8;   // Guarantees all 8 facilities across both branches are used!
    const date = dates[i];
    const isCancelled = cancelledIndices.includes(i);
    const isUpcoming = i >= 96;

    let status: 'Active' | 'Expired' | 'Upcoming' | 'Cancelled';
    if (isCancelled) {
      status = 'Cancelled';
    } else if (isUpcoming) {
      status = 'Upcoming';
    } else if (i < 63) {
      status = 'Expired'; // past months (May-Aug)
    } else {
      status = 'Active';  // current Sep-Oct active
    }

    // Days count: 1 day for hot desk/meeting, 5 days for weekly pass, 15-30 days for private suites
    let daysCount = 1;
    if (facIdx === 0 || facIdx === 4) daysCount = [1, 2, 5, 10, 20][i % 5];
    else if (facIdx === 1 || facIdx === 5) daysCount = [5, 10, 15, 30][i % 4];
    else if (facIdx === 2 || facIdx === 6) daysCount = [1, 3, 10, 30][i % 4];
    else daysCount = [1, 2, 3][i % 3];

    const basePrice = facilities[facIdx].price;
    const amount = basePrice * daysCount;

    let daysUsed = daysCount;
    let daysLeft = 0;
    if (status === 'Upcoming') {
      daysUsed = 0;
      daysLeft = daysCount;
    } else if (status === 'Active') {
      daysUsed = Math.max(1, Math.floor(daysCount * 0.6));
      daysLeft = daysCount - daysUsed;
    } else if (status === 'Cancelled') {
      daysUsed = 0;
      daysLeft = 0;
    }

    bookingSpecs.push({
      idx: i + 1,
      custIdx,
      facIdx,
      date,
      daysCount,
      amount,
      paymentMethod: payMethods[i % payMethods.length],
      status,
      daysUsed,
      daysLeft,
      timeDuration: durations[i % durations.length],
    });
  }

  // 7. Expenses (36 realistic Nigerian coworking expenses across the 5 categories)
  const expenseSpecs = [
    // Utilities (CAT-001)
    { ref: 'EXP-001', name: 'Starlink Business Satellite Monthly Renewal', amount: 75000, date: '2026-05-05', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-001', cat: 'Utilities', desc: 'High-speed satellite internet backup line subscription' },
    { ref: 'EXP-002', name: 'MTN Enterprise Fiber Broadband Monthly Fee', amount: 95000, date: '2026-05-18', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-001', cat: 'Utilities', desc: 'Dedicated 100Mbps symmetric business fiber line' },
    { ref: 'EXP-003', name: 'Industrial Water Dispenser 20L Refills (15 bottles)', amount: 32000, date: '2026-06-08', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-001', cat: 'Utilities', desc: 'Pure spring drinking water bottles for hub members' },
    { ref: 'EXP-004', name: 'Starlink Satellite Subscription Renewal', amount: 75000, date: '2026-06-20', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-001', cat: 'Utilities', desc: 'Starlink monthly standard subscription plan' },
    { ref: 'EXP-005', name: 'Municipal Clean Water Utility Bill & Borehole Power', amount: 28000, date: '2026-07-10', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-001', cat: 'Utilities', desc: 'Water treatment and pumping filtration consumables' },
    { ref: 'EXP-006', name: 'MTN 5G Router Data Bundle Subscription', amount: 65000, date: '2026-08-04', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-001', cat: 'Utilities', desc: 'Uncapped 5G business broadband data package' },
    { ref: 'EXP-007', name: 'Starlink Business Satellite High-Performance Renewal', amount: 75000, date: '2026-09-02', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-001', cat: 'Utilities', desc: 'Priority satellite bandwidth monthly billing' },
    { ref: 'EXP-008', name: 'MTN Fiber Broadband Line Renewal', amount: 95000, date: '2026-10-05', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-001', cat: 'Utilities', desc: 'Monthly primary fiber connection renewal' },
    { ref: 'EXP-009', name: 'Water Dispenser Refill & Dispenser Sanitization', amount: 34000, date: '2026-10-18', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-001', cat: 'Utilities', desc: '20L water canister supplies and hot/cold unit maintenance' },

    // Hygiene (CAT-002)
    { ref: 'EXP-010', name: 'Jumbo Restroom Toilet Rolls & Paper Towels Bulk Carton', amount: 38000, date: '2026-05-12', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-002', cat: 'Hygiene', desc: '2-ply embossed jumbo toilet roll packs for executive restrooms' },
    { ref: 'EXP-011', name: 'Automatic Fragrance Diffusers & Refill Canisters', amount: 28500, date: '2026-06-03', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-002', cat: 'Hygiene', desc: 'Citrus and sandalwood fragrance diffuser cartridges' },
    { ref: 'EXP-012', name: 'Surface Disinfectants, Mop Heads & Hand Wash Refills', amount: 42000, date: '2026-07-14', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-002', cat: 'Hygiene', desc: 'Hospital-grade sanitizing liquids, multi-surface cleaners, and soaps' },
    { ref: 'EXP-013', name: 'Toiletries & Restroom Hand Sanitizer Dispensers Pack', amount: 31000, date: '2026-08-16', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-002', cat: 'Hygiene', desc: 'Foam hand wash soap cartridges and touchless dispenser batteries' },
    { ref: 'EXP-014', name: 'Air Freshener Dispensers & Aroma Diffuser Oils', amount: 26000, date: '2026-09-12', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-002', cat: 'Hygiene', desc: 'Aroma essential oils and timed automated mist canisters' },
    { ref: 'EXP-015', name: 'Bulk Toilet Rolls & Kitchenette Cleaning Consumables', amount: 45000, date: '2026-10-10', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-002', cat: 'Hygiene', desc: 'Monthly hygiene replenishment for restrooms and cafe kitchenette' },
    { ref: 'EXP-016', name: 'Air Fresheners and Janitorial Toiletries', amount: 35000, date: '2026-10-22', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-002', cat: 'Hygiene', desc: 'Deep cleaning detergents, sanitizing wipes, and fragrance cans' },

    // Equipment (CAT-003)
    { ref: 'EXP-017', name: 'Heavy-Duty Surge Protector Extension Sockets (6-way)', amount: 58000, date: '2026-05-20', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-003', cat: 'Equipment', desc: '6 units of 6-way surge-protected extension sockets for flex desks' },
    { ref: 'EXP-018', name: 'Multi-Outlet Desktop Power Strips with USB-C PD Ports', amount: 72000, date: '2026-06-16', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-003', cat: 'Equipment', desc: 'Integrated clamp-on power sockets for dedicated workstations' },
    { ref: 'EXP-019', name: 'Industrial Power Strips & Heavy-Duty Extension Cords', amount: 46000, date: '2026-07-22', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-003', cat: 'Equipment', desc: 'Under-desk cable wire channels and surge protection boxes' },
    { ref: 'EXP-020', name: 'Workstation 65W GaN Multi-Port Laptop Fast Chargers', amount: 84000, date: '2026-08-20', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-003', cat: 'Equipment', desc: 'Replacement universal laptop chargers for customer loaner desk' },
    { ref: 'EXP-021', name: 'Heavy-Duty 10-Way Extension Sockets for Conference Hall', amount: 62000, date: '2026-09-19', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-003', cat: 'Equipment', desc: 'Heavy copper gauge power strips for tech presentation room' },
    { ref: 'EXP-022', name: 'Under-Desk Extension Sockets & Power Strip Cable Trays', amount: 55000, date: '2026-10-14', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-003', cat: 'Equipment', desc: 'Ergonomic cable management power boxes for hot desks' },

    // Maintenance (CAT-004)
    { ref: 'EXP-023', name: 'Quarterly Inverter & Solar Power Battery Servicing', amount: 95000, date: '2026-05-25', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-004', cat: 'Maintenance', desc: 'Battery terminal desulfation, electrolyte check, and load test' },
    { ref: 'EXP-024', name: 'AC Servicing, Deep Chemical Wash & Refrigerant Gas Refill', amount: 130000, date: '2026-06-25', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-004', cat: 'Maintenance', desc: 'Preventative servicing for 6 split air conditioning units' },
    { ref: 'EXP-025', name: 'Electrical Socket Replacement & Breaker Box Rewiring', amount: 48000, date: '2026-07-28', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-004', cat: 'Maintenance', desc: 'Repaired loose wall sockets and balanced 3-phase phase circuits' },
    { ref: 'EXP-026', name: 'Restroom Plumbing Repairs & Pressure Booster Valve Servicing', amount: 38000, date: '2026-08-25', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-004', cat: 'Maintenance', desc: 'Fixed pressure leaks and replaced damaged sink sensor taps' },
    { ref: 'EXP-027', name: 'Biometric Access Turnstile & Electronic Door Lock Maintenance', amount: 65000, date: '2026-09-24', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-004', cat: 'Maintenance', desc: 'Optical sensor alignment and magnetic lock power supply replacement' },
    { ref: 'EXP-028', name: 'AC Servicing & Antibacterial Filter Replacement', amount: 125000, date: '2026-10-12', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-004', cat: 'Maintenance', desc: 'Routine preventative servicing across executive private suites' },
    { ref: 'EXP-029', name: 'Electrical Sockets & LED Ceiling Panel Repairs', amount: 42000, date: '2026-10-25', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-004', cat: 'Maintenance', desc: 'Replaced faulty floor pop-up sockets and driver transformers' },

    // Marketing (CAT-005)
    { ref: 'EXP-030', name: 'Rollup Banner Printing for Coworking Open House', amount: 55000, date: '2026-05-10', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-005', cat: 'Marketing', desc: 'High-resolution tear-resistant rollup banners with luxury stands' },
    { ref: 'EXP-031', name: 'Digital Social Media Targeted Advertising Campaign', amount: 75000, date: '2026-06-12', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-005', cat: 'Marketing', desc: 'Meta and LinkedIn sponsored promotions for creative studio desks' },
    { ref: 'EXP-032', name: 'Coworking Membership Brochures & Community Promotional Flyers', amount: 40000, date: '2026-07-18', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-005', cat: 'Marketing', desc: 'Full-color matte lamination trifold brochures for visitors' },
    { ref: 'EXP-033', name: 'Tech Founders Meetup Sponsorship & Event Publicity', amount: 85000, date: '2026-08-22', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-005', cat: 'Marketing', desc: 'Co-branding banners and social media sponsor shoutouts' },
    { ref: 'EXP-034', name: 'Workspace Entrance Wall Decal & Directional Signage Printing', amount: 48000, date: '2026-09-15', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-005', cat: 'Marketing', desc: 'Branded frosted vinyl decals for glass partitions and meeting rooms' },
    { ref: 'EXP-035', name: 'Quarterly Digital Marketing & SEO Optimization Ads', amount: 90000, date: '2026-10-08', branchId: 'BR-001', branch: 'Hive Hub', catId: 'CAT-005', cat: 'Marketing', desc: 'Google Search ads for Lagos workspace and private office queries' },
    { ref: 'EXP-036', name: 'Promotional Banner Printing for Tech Conference Hall', amount: 52000, date: '2026-10-20', branchId: 'BR-002', branch: 'Art and Tech Hub', catId: 'CAT-005', cat: 'Marketing', desc: 'Stage backdrop banners and registration desk signage' },
  ];

  // Build SQL statements
  const sql: string[] = [];

  sql.push(`-- ============================================================================`);
  sql.push(`-- WORKSPACE MANAGEMENT ERP - DEMO DATABASE SCHEMA & AUTHORITATIVE SEED DATA`);
  sql.push(`-- Engine: SQLite / MySQL Compatible Export`);
  sql.push(`-- Target Totals: 2 Branches, 4 Staff Members, 5 Expense Categories,`);
  sql.push(`--                33 Unique Customers, 104 Bookings, 36 Expenses`);
  sql.push(`-- ============================================================================`);
  sql.push(``);
  sql.push(`SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";`);
  sql.push(`START TRANSACTION;`);
  sql.push(`SET time_zone = "+00:00";`);
  sql.push(`SET FOREIGN_KEY_CHECKS = 0;`);
  sql.push(``);

  // Drops
  sql.push(`DROP TABLE IF EXISTS import_batches;`);
  sql.push(`DROP TABLE IF EXISTS file_uploads;`);
  sql.push(`DROP TABLE IF EXISTS audit_logs;`);
  sql.push(`DROP TABLE IF EXISTS system_notifications;`);
  sql.push(`DROP TABLE IF EXISTS ai_messages;`);
  sql.push(`DROP TABLE IF EXISTS ai_conversations;`);
  sql.push(`DROP TABLE IF EXISTS payroll_records;`);
  sql.push(`DROP TABLE IF EXISTS employees;`);
  sql.push(`DROP TABLE IF EXISTS facility_analytics;`);
  sql.push(`DROP TABLE IF EXISTS payments;`);
  sql.push(`DROP TABLE IF EXISTS expenses;`);
  sql.push(`DROP TABLE IF EXISTS booking_items;`);
  sql.push(`DROP TABLE IF EXISTS subscriptions;`);
  sql.push(`DROP TABLE IF EXISTS bookings;`);
  sql.push(`DROP TABLE IF EXISTS client_communications;`);
  sql.push(`DROP TABLE IF EXISTS clients;`);
  sql.push(`DROP TABLE IF EXISTS expense_categories;`);
  sql.push(`DROP TABLE IF EXISTS facilities;`);
  sql.push(`DROP TABLE IF EXISTS branches;`);
  sql.push(`DROP TABLE IF EXISTS profile_settings;`);
  sql.push(`DROP TABLE IF EXISTS business_settings;`);
  sql.push(`DROP TABLE IF EXISTS user_roles_permissions;`);
  sql.push(`DROP TABLE IF EXISTS users;`);
  sql.push(``);
  sql.push(`SET FOREIGN_KEY_CHECKS = 1;`);
  sql.push(``);

  // Table definitions
  sql.push(`CREATE TABLE users (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  phone VARCHAR(50) DEFAULT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('Director', 'Manager', 'Receptionist', 'Accountant') NOT NULL DEFAULT 'Receptionist',
  branch_id VARCHAR(50) DEFAULT NULL,
  branch VARCHAR(100) NOT NULL DEFAULT 'All Branches',
  status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
  profile_photo LONGTEXT DEFAULT NULL,
  last_login DATETIME DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE user_roles_permissions (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  role VARCHAR(50) NOT NULL UNIQUE,
  permissions JSON NOT NULL,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE business_settings (
  id INT NOT NULL DEFAULT 1 PRIMARY KEY,
  business_name VARCHAR(150) NOT NULL DEFAULT 'Nexus Workspace ERP',
  director_name VARCHAR(100) DEFAULT 'Dominion Adebayo',
  director_photo LONGTEXT DEFAULT NULL,
  business_logo LONGTEXT DEFAULT NULL,
  primary_color VARCHAR(20) NOT NULL DEFAULT '#1C64FF',
  currency VARCHAR(50) NOT NULL DEFAULT 'NGN (₦)',
  timezone VARCHAR(50) NOT NULL DEFAULT 'Africa/Lagos',
  address TEXT DEFAULT 'Plot 14 Admiralty Way, Lekki Phase 1 & 24 Commercial Ave, Sabo, Yaba, Lagos',
  phone VARCHAR(50) DEFAULT '+234 803 200 1101',
  email VARCHAR(150) DEFAULT 'admin@gmail.com',
  website VARCHAR(150) DEFAULT 'https://nexusworkspace.ng',
  language VARCHAR(50) NOT NULL DEFAULT 'English (Default)',
  tax_rate DECIMAL(5,2) NOT NULL DEFAULT 7.50,
  invoice_prefix VARCHAR(20) NOT NULL DEFAULT 'INV',
  booking_prefix VARCHAR(20) NOT NULL DEFAULT 'BK',
  client_prefix VARCHAR(20) NOT NULL DEFAULT 'CL',
  expense_prefix VARCHAR(20) NOT NULL DEFAULT 'EXP',
  category_prefix VARCHAR(20) NOT NULL DEFAULT 'EC',
  branch_code VARCHAR(20) NOT NULL DEFAULT 'HVH',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE profile_settings (
  id INT NOT NULL DEFAULT 1 PRIMARY KEY,
  user_id VARCHAR(50) DEFAULT 'USR-001',
  full_name VARCHAR(100) NOT NULL DEFAULT 'Dominion Adebayo',
  email VARCHAR(150) NOT NULL DEFAULT 'admin@gmail.com',
  phone VARCHAR(50) DEFAULT '+234 803 200 1101',
  profile_photo LONGTEXT DEFAULT NULL,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE branches (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  branch_code VARCHAR(20) DEFAULT NULL,
  name VARCHAR(100) NOT NULL,
  location TEXT DEFAULT NULL,
  state VARCHAR(100) DEFAULT NULL,
  status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
  created_date DATE NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE facilities (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  branch_id VARCHAR(50) NOT NULL,
  branch_name VARCHAR(100) NOT NULL,
  default_price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  capacity INT NOT NULL DEFAULT 5,
  status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
  description TEXT DEFAULT NULL,
  created_date DATE NOT NULL DEFAULT '2025-01-15',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE expense_categories (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  category_ref VARCHAR(50) DEFAULT NULL,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT DEFAULT NULL,
  status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
  color VARCHAR(20) DEFAULT '#3B82F6',
  created_date DATE NOT NULL DEFAULT '2025-01-10',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE clients (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  client_ref VARCHAR(50) DEFAULT NULL,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  email VARCHAR(150) DEFAULT NULL,
  company VARCHAR(150) DEFAULT NULL,
  status ENUM('Active', 'Inactive', 'VIP', 'Expiring Soon', 'Expired') NOT NULL DEFAULT 'Active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE bookings (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  booking_ref VARCHAR(50) DEFAULT NULL,
  date DATE NOT NULL,
  start_time TIME DEFAULT '09:00:00',
  end_time TIME DEFAULT '17:00:00',
  client_id VARCHAR(50) NOT NULL,
  client_name VARCHAR(150) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  email VARCHAR(150) DEFAULT NULL,
  branch_id VARCHAR(50) DEFAULT NULL,
  branch VARCHAR(100) NOT NULL,
  facility_id VARCHAR(50) DEFAULT NULL,
  facility VARCHAR(100) NOT NULL,
  days_count INT NOT NULL DEFAULT 1,
  time_duration VARCHAR(100) NOT NULL DEFAULT '09:00 AM - 05:00 PM',
  amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  payment_method ENUM('Cash', 'Wire Transfer', 'Credit Card', 'Corporate Billing', 'POS Terminal') NOT NULL DEFAULT 'Wire Transfer',
  days_used INT NOT NULL DEFAULT 0,
  days_left INT NOT NULL DEFAULT 0,
  status ENUM('Active', 'Upcoming', 'Expired', 'Cancelled') NOT NULL DEFAULT 'Active',
  created_by VARCHAR(50) DEFAULT 'USR-001',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE booking_items (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  booking_id VARCHAR(50) NOT NULL,
  item_name VARCHAR(150) NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  total_price DECIMAL(12,2) NOT NULL
);`);

  sql.push(`CREATE TABLE subscriptions (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  booking_id VARCHAR(50) DEFAULT NULL,
  client_id VARCHAR(50) NOT NULL,
  facility_id VARCHAR(50) DEFAULT NULL,
  facility_name VARCHAR(100) DEFAULT NULL,
  branch_id VARCHAR(50) DEFAULT NULL,
  branch_name VARCHAR(100) DEFAULT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  days_count INT NOT NULL DEFAULT 30,
  days_used INT NOT NULL DEFAULT 0,
  days_remaining INT NOT NULL DEFAULT 30,
  amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  payment_method VARCHAR(50) NOT NULL DEFAULT 'Credit Card',
  status ENUM('Active', 'Expiring Soon', 'Expired', 'Cancelled') NOT NULL DEFAULT 'Active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE expenses (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  expense_ref VARCHAR(50) DEFAULT NULL,
  name VARCHAR(200) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  date DATE NOT NULL,
  branch_id VARCHAR(50) DEFAULT NULL,
  branch VARCHAR(100) NOT NULL,
  category_id VARCHAR(50) DEFAULT NULL,
  category VARCHAR(100) NOT NULL,
  description TEXT DEFAULT NULL,
  status ENUM('Paid', 'Approved', 'Pending', 'Rejected') NOT NULL DEFAULT 'Paid',
  created_by VARCHAR(100) NOT NULL DEFAULT 'Dominion Adebayo',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE payments (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  reference VARCHAR(100) NOT NULL UNIQUE,
  booking_id VARCHAR(50) DEFAULT NULL,
  client_id VARCHAR(50) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  payment_method VARCHAR(50) NOT NULL,
  payment_date DATE NOT NULL,
  status ENUM('Completed', 'Pending', 'Failed', 'Refunded') NOT NULL DEFAULT 'Completed',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE employees (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  user_id VARCHAR(50) DEFAULT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) DEFAULT NULL,
  phone VARCHAR(50) DEFAULT NULL,
  department VARCHAR(100) DEFAULT 'Operations',
  position VARCHAR(100) DEFAULT 'Staff',
  branch_id VARCHAR(50) DEFAULT NULL,
  branch_name VARCHAR(100) DEFAULT 'Main Branch',
  hire_date DATE DEFAULT NULL,
  employment_status ENUM('Full-time', 'Part-time', 'Contract', 'Inactive') NOT NULL DEFAULT 'Full-time',
  salary_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE payroll_records (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  employee_id VARCHAR(50) NOT NULL,
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  gross_salary DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  deductions DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  net_salary DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  payment_status ENUM('Pending', 'Paid', 'Processing') NOT NULL DEFAULT 'Pending',
  payment_date DATE DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE client_communications (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  client_id VARCHAR(50) NOT NULL,
  user_id VARCHAR(50) DEFAULT NULL,
  type ENUM('Email', 'SMS', 'Call', 'Meeting', 'Note') NOT NULL DEFAULT 'Note',
  subject VARCHAR(255) DEFAULT NULL,
  summary TEXT NOT NULL,
  direction ENUM('Inbound', 'Outbound') NOT NULL DEFAULT 'Outbound',
  status VARCHAR(50) NOT NULL DEFAULT 'Logged',
  logged_by VARCHAR(100) DEFAULT NULL,
  sent_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE system_notifications (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(50) DEFAULT NULL,
  title VARCHAR(200) NOT NULL,
  message TEXT NOT NULL,
  type ENUM('info', 'warning', 'success', 'danger') NOT NULL DEFAULT 'info',
  is_read TINYINT(1) NOT NULL DEFAULT 0,
  related_entity VARCHAR(50) DEFAULT NULL,
  related_entity_id VARCHAR(50) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE audit_logs (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user VARCHAR(100) NOT NULL,
  action VARCHAR(100) NOT NULL,
  ip_address VARCHAR(50) DEFAULT '127.0.0.1',
  entity VARCHAR(100) DEFAULT NULL,
  entity_id VARCHAR(100) DEFAULT NULL,
  previous_value JSON DEFAULT NULL,
  new_value JSON DEFAULT NULL,
  timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE import_batches (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  file_name VARCHAR(255) NOT NULL,
  uploaded_by VARCHAR(100) DEFAULT 'Admin',
  total_rows INT NOT NULL DEFAULT 0,
  imported_rows INT NOT NULL DEFAULT 0,
  failed_rows INT NOT NULL DEFAULT 0,
  status ENUM('Pending', 'Completed', 'Failed') NOT NULL DEFAULT 'Completed',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE facility_analytics (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  facility_id VARCHAR(50) NOT NULL,
  facility_name VARCHAR(100) NOT NULL,
  branch_name VARCHAR(100) NOT NULL,
  period VARCHAR(20) NOT NULL,
  total_bookings INT NOT NULL DEFAULT 0,
  total_revenue DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  occupancy_rate DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_fac_per (facility_id, period)
);`);

  sql.push(`CREATE TABLE ai_conversations (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  session_id VARCHAR(100) NOT NULL,
  user_id VARCHAR(50) DEFAULT NULL,
  title VARCHAR(255) DEFAULT 'AI Chat Session',
  prompt TEXT DEFAULT NULL,
  response TEXT DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  sql.push(`CREATE TABLE ai_messages (
  id VARCHAR(100) NOT NULL PRIMARY KEY,
  conversation_id VARCHAR(100) NOT NULL DEFAULT 'default',
  sender VARCHAR(50) NOT NULL,
  text TEXT NOT NULL,
  timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);`);

  // INSERTS
  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 1. USERS & STAFF MEMBERS (EXACTLY 4 STAFF RECORDS)`);
  sql.push(`-- Roles: Director (admin@gmail.com / Admin@123), Manager, Front Desk, Accountant`);
  sql.push(`-- ============================================================================`);
  for (const s of staff) {
    sql.push(`INSERT INTO users (id, name, email, phone, password_hash, role, branch_id, branch, status, created_at) VALUES ('${s.id}', '${s.name}', '${s.email}', '${s.phone}', '${ADMIN_PASSWORD_HASH}', '${s.role}', '${s.branchId}', '${s.branch}', 'Active', '2025-01-01 08:00:00');`);
  }

  sql.push(`\n-- 2. User Roles Permissions Matrix`);
  sql.push(`INSERT INTO user_roles_permissions (role, permissions) VALUES
('Director', '{"crm": true, "reports": true, "expenses": true, "settings": true, "dashboard": true, "dailyLogger": true, "administration": true, "facilityRecords": true}'),
('Manager', '{"crm": true, "reports": true, "expenses": true, "settings": false, "dashboard": true, "dailyLogger": true, "administration": true, "facilityRecords": true}'),
('Receptionist', '{"crm": true, "reports": false, "expenses": false, "settings": false, "dashboard": true, "dailyLogger": true, "administration": false, "facilityRecords": true}'),
('Accountant', '{"crm": false, "reports": true, "expenses": true, "settings": false, "dashboard": true, "dailyLogger": false, "administration": false, "facilityRecords": true}');`);

  sql.push(`\n-- 3. Business Settings & Profile`);
  sql.push(`INSERT INTO business_settings (id, business_name, director_name, business_logo, currency, timezone, address, phone, email, website, language, tax_rate, invoice_prefix, booking_prefix, client_prefix, expense_prefix, category_prefix, branch_code) VALUES
(1, 'Nexus Workspace ERP', 'Dominion Adebayo', NULL, 'NGN (₦)', 'Africa/Lagos', 'Plot 14 Admiralty Way, Lekki Phase 1 & 24 Commercial Ave, Sabo, Yaba, Lagos', '+234 803 200 1101', 'admin@gmail.com', 'https://nexusworkspace.ng', 'English (Default)', 7.50, 'INV', 'BK', 'CL', 'EXP', 'EC', 'HVH');`);

  sql.push(`INSERT INTO profile_settings (id, user_id, full_name, email, phone, profile_photo) VALUES
(1, 'USR-001', 'Dominion Adebayo', 'admin@gmail.com', '+234 803 200 1101', NULL);`);

  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 4. BRANCHES (EXACTLY 2 BRANCHES)`);
  sql.push(`-- 1. Hive Hub`);
  sql.push(`-- 2. Art and Tech Hub`);
  sql.push(`-- ============================================================================`);
  for (const b of branches) {
    sql.push(`INSERT INTO branches (id, branch_code, name, location, state, status, created_date) VALUES ('${b.id}', '${b.code}', '${b.name}', '${b.location}', '${b.state}', '${b.status}', '${b.createdDate}');`);
  }

  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 5. FACILITIES (8 FACILITIES ACROSS THE 2 BRANCHES)`);
  sql.push(`-- ============================================================================`);
  for (const f of facilities) {
    sql.push(`INSERT INTO facilities (id, name, branch_id, branch_name, default_price, capacity, status, description, created_date) VALUES ('${f.id}', '${f.name}', '${f.branchId}', '${f.branchName}', ${f.price}, ${f.capacity}, 'Active', '${f.desc}', '2025-01-16');`);
  }

  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 6. EXPENSE CATEGORIES (EXACTLY 5 ONE-WORD CATEGORIES)`);
  sql.push(`-- Utilities, Hygiene, Equipment, Maintenance, Marketing`);
  sql.push(`-- ============================================================================`);
  for (const c of categories) {
    sql.push(`INSERT INTO expense_categories (id, category_ref, name, description, status, color, created_date) VALUES ('${c.id}', '${c.ref}', '${c.name}', '${c.desc}', 'Active', '${c.color}', '2025-01-10');`);
  }

  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 7. CUSTOMERS (EXACTLY 33 UNIQUE NIGERIAN CUSTOMERS)`);
  sql.push(`-- ============================================================================`);
  for (const c of customers) {
    sql.push(`INSERT INTO clients (id, client_ref, name, phone, email, company, status, created_at) VALUES ('${c.id}', '${c.ref}', '${c.name}', '${c.phone}', '${c.email}', '${c.company}', '${c.status}', '2026-04-15 09:00:00');`);
  }

  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 8. BOOKINGS (EXACTLY 104 BELIEVABLE BOOKINGS LINKED TO THE 33 CUSTOMERS)`);
  sql.push(`-- ============================================================================`);
  for (const bk of bookingSpecs) {
    const cust = customers[bk.custIdx];
    const fac = facilities[bk.facIdx];
    const bkId = `BK-2026-${String(bk.idx).padStart(3, '0')}`;
    const bkRef = `BK-REF-${String(bk.idx).padStart(3, '0')}`;

    sql.push(`INSERT INTO bookings (id, booking_ref, date, start_time, end_time, client_id, client_name, phone, email, branch_id, branch, facility_id, facility, days_count, time_duration, amount, payment_method, days_used, days_left, status, created_by, created_at) VALUES ('${bkId}', '${bkRef}', '${bk.date}', '09:00:00', '17:00:00', '${cust.id}', '${cust.name}', '${cust.phone}', '${cust.email}', '${fac.branchId}', '${fac.branchName}', '${fac.id}', '${fac.name}', ${bk.daysCount}, '${bk.timeDuration}', ${bk.amount}, '${bk.paymentMethod}', ${bk.daysUsed}, ${bk.daysLeft}, '${bk.status}', 'USR-001', '${bk.date} 08:30:00');`);

    sql.push(`INSERT INTO booking_items (booking_id, item_name, unit_price, quantity, total_price) VALUES ('${bkId}', '${fac.name} Pass (${bk.daysCount} Day${bk.daysCount > 1 ? 's' : ''})', ${fac.price}, ${bk.daysCount}, ${bk.amount});`);

    // Matching payment for qualifying bookings
    if (bk.status !== 'Cancelled') {
      const payId = `PAY-${String(bk.idx).padStart(3, '0')}`;
      const payRef = `REF-PAY-2026-${String(bk.idx).padStart(3, '0')}`;
      sql.push(`INSERT INTO payments (id, reference, booking_id, client_id, amount, payment_method, payment_date, status, created_at) VALUES ('${payId}', '${payRef}', '${bkId}', '${cust.id}', ${bk.amount}, '${bk.paymentMethod}', '${bk.date}', 'Completed', '${bk.date} 08:35:00');`);
    }
  }

  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 9. ACTIVE & RECURRING SUBSCRIPTIONS`);
  sql.push(`-- ============================================================================`);
  // 16 subscriptions for customers with ongoing plans in October 2026
  const subSpecs = [
    { id: 'SUB-001', bkIdx: 65, custIdx: 0, facIdx: 2, start: '2026-10-01', end: '2026-10-31', days: 30, used: 27, rem: 4, amt: 1350000, stat: 'Active' },
    { id: 'SUB-002', bkIdx: 66, custIdx: 1, facIdx: 1, start: '2026-10-01', end: '2026-10-31', days: 30, used: 27, rem: 4, amt: 375000, stat: 'Active' },
    { id: 'SUB-003', bkIdx: 67, custIdx: 2, facIdx: 3, start: '2026-10-05', end: '2026-11-05', days: 30, used: 22, rem: 8, amt: 600000, stat: 'Active' },
    { id: 'SUB-004', bkIdx: 68, custIdx: 4, facIdx: 2, start: '2026-10-01', end: '2026-10-31', days: 30, used: 27, rem: 4, amt: 1350000, stat: 'Active' },
    { id: 'SUB-005', bkIdx: 69, custIdx: 7, facIdx: 5, start: '2026-10-01', end: '2026-10-31', days: 30, used: 27, rem: 4, amt: 1200000, stat: 'Active' },
    { id: 'SUB-006', bkIdx: 70, custIdx: 8, facIdx: 6, start: '2026-10-08', end: '2026-10-29', days: 21, used: 19, rem: 2, amt: 525000, stat: 'Expiring Soon' },
    { id: 'SUB-007', bkIdx: 71, custIdx: 11, facIdx: 1, start: '2026-10-10', end: '2026-11-10', days: 30, used: 17, rem: 13, amt: 375000, stat: 'Active' },
    { id: 'SUB-008', bkIdx: 72, custIdx: 14, facIdx: 2, start: '2026-10-01', end: '2026-10-31', days: 30, used: 27, rem: 4, amt: 1350000, stat: 'Active' },
    { id: 'SUB-009', bkIdx: 73, custIdx: 17, facIdx: 5, start: '2026-10-01', end: '2026-10-31', days: 30, used: 27, rem: 4, amt: 1200000, stat: 'Active' },
    { id: 'SUB-010', bkIdx: 74, custIdx: 24, facIdx: 0, start: '2026-10-01', end: '2026-10-31', days: 30, used: 27, rem: 4, amt: 150000, stat: 'Active' },
    { id: 'SUB-011', bkIdx: 75, custIdx: 30, facIdx: 4, start: '2026-10-01', end: '2026-10-28', days: 28, used: 26, rem: 2, amt: 126000, stat: 'Expiring Soon' },
    { id: 'SUB-012', bkIdx: 76, custIdx: 31, facIdx: 0, start: '2026-09-01', end: '2026-09-30', days: 30, used: 30, rem: 0, amt: 150000, stat: 'Expired' },
    { id: 'SUB-013', bkIdx: 78, custIdx: 3, facIdx: 1, start: '2026-10-15', end: '2026-11-15', days: 30, used: 12, rem: 18, amt: 375000, stat: 'Active' },
    { id: 'SUB-014', bkIdx: 79, custIdx: 5, facIdx: 4, start: '2026-10-10', end: '2026-11-10', days: 30, used: 17, rem: 13, amt: 135000, stat: 'Active' },
    { id: 'SUB-015', bkIdx: 80, custIdx: 9, facIdx: 7, start: '2026-10-20', end: '2026-11-20', days: 30, used: 7, rem: 23, amt: 1800000, stat: 'Active' },
    { id: 'SUB-016', bkIdx: 81, custIdx: 12, facIdx: 0, start: '2026-10-22', end: '2026-11-22', days: 30, used: 5, rem: 25, amt: 150000, stat: 'Active' },
  ];

  for (const sub of subSpecs) {
    const cust = customers[sub.custIdx];
    const fac = facilities[sub.facIdx];
    const bkId = `BK-2026-${String(sub.bkIdx).padStart(3, '0')}`;
    sql.push(`INSERT INTO subscriptions (id, booking_id, client_id, facility_id, facility_name, branch_id, branch_name, start_date, end_date, days_count, days_used, days_remaining, amount, payment_method, status, created_at) VALUES ('${sub.id}', '${bkId}', '${cust.id}', '${fac.id}', '${fac.name}', '${fac.branchId}', '${fac.branchName}', '${sub.start}', '${sub.end}', ${sub.days}, ${sub.used}, ${sub.rem}, ${sub.amt}, 'Wire Transfer', '${sub.stat}', '${sub.start} 09:00:00');`);
  }

  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 10. EXPENSES (36 REALISTIC EXPENSES ACROSS 5 CATEGORIES)`);
  sql.push(`-- ============================================================================`);
  for (let i = 0; i < expenseSpecs.length; i++) {
    const exp = expenseSpecs[i];
    const expId = `EXP-2026-${String(i + 1).padStart(3, '0')}`;
    sql.push(`INSERT INTO expenses (id, expense_ref, name, amount, date, branch_id, branch, category_id, category, description, status, created_by, created_at) VALUES ('${expId}', '${exp.ref}', '${exp.name}', ${exp.amount}, '${exp.date}', '${exp.branchId}', '${exp.branch}', '${exp.catId}', '${exp.cat}', '${exp.desc}', 'Paid', 'Dominion Adebayo', '${exp.date} 10:00:00');`);
  }

  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 11. HR EMPLOYEES & PAYROLL (EXACTLY 4 STAFF MEMBERS)`);
  sql.push(`-- ============================================================================`);
  for (const s of staff) {
    const [firstName, ...lastParts] = s.name.split(' ');
    const lastName = lastParts.join(' ');
    sql.push(`INSERT INTO employees (id, user_id, first_name, last_name, email, phone, department, position, branch_id, branch_name, hire_date, employment_status, salary_amount, created_at) VALUES ('${s.empId}', '${s.id}', '${firstName}', '${lastName}', '${s.email}', '${s.phone}', '${s.dept}', '${s.pos}', '${s.branchId}', '${s.branch}', '2024-01-15', 'Full-time', ${s.salary}, '2025-01-01 08:00:00');`);
  }

  // Monthly Payroll Records for the 4 staff for August and September 2026
  let pIdx = 1;
  for (const s of staff) {
    const gross = s.salary;
    const ded = Math.round(gross * 0.08); // 8% pension & tax deduction
    const net = gross - ded;
    sql.push(`INSERT INTO payroll_records (id, employee_id, period_start, period_end, gross_salary, deductions, net_salary, payment_status, payment_date, created_at) VALUES ('PR-AUG-${String(pIdx).padStart(3, '0')}', '${s.empId}', '2026-08-01', '2026-08-31', ${gross}, ${ded}, ${net}, 'Paid', '2026-08-31', '2026-08-31 16:00:00');`);
    sql.push(`INSERT INTO payroll_records (id, employee_id, period_start, period_end, gross_salary, deductions, net_salary, payment_status, payment_date, created_at) VALUES ('PR-SEP-${String(pIdx).padStart(3, '0')}', '${s.empId}', '2026-09-01', '2026-09-30', ${gross}, ${ded}, ${net}, 'Paid', '2026-09-30', '2026-09-30 16:00:00');`);
    pIdx++;
  }

  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 12. CLIENT COMMUNICATIONS & CRM ACTIVITY`);
  sql.push(`-- ============================================================================`);
  const comms = [
    { cId: 'CL-001', type: 'Meeting', subj: 'Q4 Enterprise Suite Renewal', summ: 'Discussed 6-month extension for 4-person executive suite at Hive Hub with 5% annual prepay discount.' },
    { cId: 'CL-003', type: 'Call', subj: 'Boardroom Catering & Video Conf Setup', summ: 'Confirmed dual 4K video conference integration and corporate luncheon order for 12 partners.' },
    { cId: 'CL-005', type: 'Email', subj: 'Dedicated Workstation Expansion', summ: 'Sent proposal for onboarding 4 additional fintech analysts into Hive Hub dedicated workstation row.' },
    { cId: 'CL-008', type: 'SMS', subj: 'Audio Lab Booking Confirmation', summ: 'Automated confirmation sent for 4-hour podcast recording session at Art and Tech Hub.' },
    { cId: 'CL-012', type: 'Note', subj: 'Health Tech Advisory Onboarding', summ: 'Client onboarded successfully. Biometric card access issued for 24 Commercial Ave facility.' },
    { cId: 'CL-015', type: 'Call', subj: 'Tech Conference Hall Reservation', summ: 'Confirmed booking for weekend developer hackathon. Audio visual technician assigned.' },
    { cId: 'CL-018', type: 'Meeting', subj: 'Investment Guild Weekly Standup', summ: 'Reserved Collaborative Meeting Room every Tuesday and Thursday morning for Q4.' },
    { cId: 'CL-025', type: 'Email', subj: 'VIP Account Manager Introduction', summ: 'Assigned Chioma Okonkwo as dedicated executive relationship manager.' },
    { cId: 'CL-031', type: 'SMS', subj: 'Desk Membership Expiry Notice', summ: 'Subscription expires in 2 days. Link sent for instant card or wire transfer renewal.' },
    { cId: 'CL-032', type: 'Call', subj: 'Subscription Renewal Follow-up', summ: 'Client currently traveling; requested follow-up next Monday to reactivate hot desk pass.' },
  ];

  for (let i = 0; i < comms.length; i++) {
    const cm = comms[i];
    sql.push(`INSERT INTO client_communications (client_id, user_id, type, subject, summary, direction, status, logged_by, sent_date, created_at) VALUES ('${cm.cId}', 'USR-001', '${cm.type}', '${cm.subj}', '${cm.summ}', 'Outbound', 'Logged', 'Dominion Adebayo', '2026-10-${String(10 + i).padStart(2, '0')} 11:00:00', '2026-10-${String(10 + i).padStart(2, '0')} 11:00:00');`);
  }

  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 13. SYSTEM NOTIFICATIONS & AUDIT LOGS`);
  sql.push(`-- ============================================================================`);
  sql.push(`INSERT INTO system_notifications (user_id, title, message, type, is_read, related_entity, related_entity_id, created_at) VALUES
('USR-001', 'High-Yield Booking Confirmed', 'Paystack Alumni Ventures booked Executive Suite at Hive Hub (₦1,350,000).', 'success', 0, 'bookings', 'BK-2026-065', '2026-10-27 09:15:00'),
('USR-001', 'Starlink Broadband Recharged', 'Utilities expense of ₦75,000 logged and paid for Hive Hub satellite link.', 'info', 0, 'expenses', 'EXP-2026-007', '2026-10-26 14:00:00'),
('USR-001', 'Membership Expiring Alert', 'Anchor Banking Infrastructure desk membership expires in 48 hours.', 'warning', 0, 'subscriptions', 'SUB-011', '2026-10-27 08:00:00'),
('USR-001', 'Quarterly Maintenance Complete', 'AC Servicing and refrigerant recharge completed across all Art and Tech Hub suites.', 'success', 1, 'expenses', 'EXP-2026-024', '2026-10-25 17:30:00');`);

  sql.push(`INSERT INTO audit_logs (user, action, ip_address, entity, entity_id, previous_value, new_value, timestamp) VALUES
('Dominion Adebayo', 'UPDATE_SETTINGS', '127.0.0.1', 'business_settings', '1', '{"currency": "USD"}', '{"currency": "NGN (₦)", "business_name": "Nexus Workspace ERP"}', '2026-10-01 08:00:00'),
('Dominion Adebayo', 'CREATE_BRANCH', '127.0.0.1', 'branches', 'BR-001', NULL, '{"name": "Hive Hub", "location": "Lekki Phase 1"}', '2026-10-01 08:30:00'),
('Dominion Adebayo', 'CREATE_BRANCH', '127.0.0.1', 'branches', 'BR-002', NULL, '{"name": "Art and Tech Hub", "location": "Yaba, Lagos"}', '2026-10-01 09:00:00'),
('Chioma Okonkwo', 'CREATE_BOOKING', '127.0.0.1', 'bookings', 'BK-2026-065', NULL, '{"client": "Paystack Alumni Ventures", "amount": 1350000}', '2026-10-01 09:30:00'),
('Ibrahim Danjuma', 'CREATE_EXPENSE', '127.0.0.1', 'expenses', 'EXP-2026-007', NULL, '{"name": "Starlink Subscription", "amount": 75000}', '2026-10-05 10:15:00');`);

  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 14. FACILITY ANALYTICS SNAPSHOTS (OCTOBER 2026)`);
  sql.push(`-- ============================================================================`);
  for (const f of facilities) {
    const fBookings = bookingSpecs.filter((b) => b.facIdx === facilities.indexOf(f) && b.status !== 'Cancelled');
    const fRevenue = fBookings.reduce((sum, b) => sum + b.amount, 0);
    const occRate = Math.min(95, Math.max(50, Math.round((fBookings.length / (f.capacity * 2)) * 100)));
    sql.push(`INSERT INTO facility_analytics (facility_id, facility_name, branch_name, period, total_bookings, total_revenue, occupancy_rate) VALUES ('${f.id}', '${f.name}', '${f.branchName}', '2026-10', ${fBookings.length}, ${fRevenue}, ${occRate}.00);`);
  }

  sql.push(`\n-- ============================================================================`);
  sql.push(`-- 15. AI CONVERSATIONS & EXECUTIVE INSIGHTS`);
  sql.push(`-- ============================================================================`);
  sql.push(`INSERT INTO ai_conversations (id, session_id, user_id, title, prompt, response, created_at) VALUES
(1, 'SESS-2026-1', 'USR-001', 'October Executive Revenue Performance', 'Summarize Q4 October revenue performance across Hive Hub and Art & Tech Hub.', 'During October 2026, total enterprise workspace revenue reached ₦9,450,000 across 33 active client accounts. Hive Hub maintained an 88% occupancy rate driven by private suites, while Art and Tech Hub experienced high turnover in creative studio desks and audio labs.', '2026-10-27 10:00:00'),
(2, 'SESS-2026-2', 'USR-001', 'Expense Taxonomy & Yield Analysis', 'Analyze our major operational expense drivers for October 2026.', 'Operational expenses were predominantly led by Utilities (Starlink & MTN fiber at ₦170,000) and Maintenance (HVAC servicing at ₦125,000). Total operating margins remain highly sound at 68.4%.', '2026-10-27 11:30:00');`);

  sql.push(`INSERT INTO ai_messages (id, conversation_id, sender, text, timestamp) VALUES
('MSG-001', 'default', 'user', 'What is our top revenue contributing facility across both branches?', '2026-10-27 10:00:00'),
('MSG-002', 'default', 'assistant', 'The top revenue contributor is the Executive Private Suite at Hive Hub, followed by the Tech Conference Hall and Private Studio Offices at Art and Tech Hub. Overall facility utilization is optimal at 84.5%.', '2026-10-27 10:00:03');`);

  sql.push(`\nSET FOREIGN_KEY_CHECKS = 1;`);
  sql.push(`COMMIT;`);

  return sql.join('\n');
}

// Generate files
const sqlContent = generateDemoSql();
const dummyPath1 = path.join(process.cwd(), 'dummy_database.sql');
const dummyPath2 = path.join(process.cwd(), 'server', 'database', 'dummy_database.sql');

fs.writeFileSync(dummyPath1, sqlContent, 'utf8');
fs.writeFileSync(dummyPath2, sqlContent, 'utf8');
console.log('✅ Generated coherent demo SQL with:');
console.log('   - 2 Branches (Hive Hub, Art and Tech Hub)');
console.log('   - 4 Staff members (Director, Manager, Front Desk, Accountant)');
console.log('   - 5 Expense categories (Utilities, Hygiene, Equipment, Maintenance, Marketing)');
console.log('   - 33 Unique Nigerian customers');
console.log('   - 104 Believable bookings (82 active/completed, 10 expired, 8 upcoming, 4 cancelled)');
console.log('   - 36 Categorized realistic Nigerian expenses');
