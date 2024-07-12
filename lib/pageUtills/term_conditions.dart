import 'package:flutter/material.dart';

import 'common_appbar.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CommonAppBar(title: 'Terms and Conditions'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Terms Of Use ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Claco Store',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' is a trademark of "',
                      style: TextStyle(
                          color: Colors.grey[40],
                          fontSize: 12
                      ),
                    ),
                    const TextSpan(
                      text: 'Claco Online Service pvt Ltd',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                        '” a company incorporated under the Companies Act, 2021 with its registered office at 12B/989, near Utrathia Junction, Sector 12, Vrindavan Colony, Baraulikhalilabad, Uttar Pradesh 226029. The domain name ',
                        style: TextStyle(
                            color: Colors.grey[40],
                            fontSize: 12
                        )),
                    const TextSpan(
                      text: 'www.claco.in',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                      ' is owned by the Company. Please feel free to reach out to us at our Customer Care helpline: ',
                      style: TextStyle(
                          color: Colors.grey[40],
                          fontSize: 12
                      ),),
                    const TextSpan(
                      text: '+91-7800008041 .',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Acceptance of Terms',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Thank you for choosing',
                          style: TextStyle(
                              color: Colors.grey[40],
                              fontSize: 12
                          ),
                        ),
                        const TextSpan(
                          text: '“Claco Store”',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '. These Terms of Use (the "Terms") are intended to make you aware of your legal rights and responsibilities with respect to your access to and use of the Claco Store website at www.claco.in (the "Site") and any related mobile or software applications ',
                          style: TextStyle(
                              color: Colors.grey[40],
                              fontSize: 12
                          ),),
                        TextSpan(
                          text:
                          '( ',
                          style: TextStyle(
                              color: Colors.grey[40],
                              fontSize: 12
                          ),
                        ),
                        const TextSpan(
                          text: '“Claco Store”',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                          ') ',
                          style: TextStyle(
                              color: Colors.grey[40],
                              fontSize: 12
                          ),
                        ),
                        TextSpan(
                          text:
                          'Platform including but not limited to delivery of information via the website whether existing now or in the future that link to the Terms (collectively, the "Services").',
                          style: TextStyle(
                              color: Colors.grey[40],
                              fontSize: 12
                          ),
                        ),
                      ]
                  )
              ),
              const SizedBox(height: 2),
              Text(
                'These Terms are effective for all existing and future Claco Store customers. By accessing this site (hereinafter the “Marketplace”), you agree to be bound by the same and acknowledge that it constitutes an agreement between you and the Company (hereinafter the “User Agreement”). You may not use the Services if you do not accept the Terms or are unable to be bound by the Terms. Your use of the Claco Store Platform is at your own risk, including the risk that you might be exposed to content that is objectionable, or otherwise inappropriate.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'This document is published in accordance with the provisions of Rule 3 of the Information Technology (Intermediaries Guidelines) Rules, 2011. The User Agreement may be updated from time to time by the Company without notice. It is therefore strongly recommended that you review the User Agreement, as available on the Marketplace, each time you access and/or use the Marketplace.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              RichText(
                text:  TextSpan(
                  children: [
                    TextSpan(
                      text: 'The terms ‘visitor(s)’, ‘user(s)’, ‘you’ hereunder refer to the person visiting, accessing, browsing through and/or using the Marketplace at any point in time. Should you have need clarifications regarding the Terms of Use, please do write to us at',
                      style: TextStyle(
                          color: Colors.grey[40],
                          fontSize: 12
                      ),
                    ),
                    const TextSpan(
                      text: ' contact@claco.in',
                      style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.pink,),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Services Overview',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'The Marketplace is a platform for domestic consumers to transact with third party sellers, who have been granted access to the Marketplace to display and offer products for sale through the Marketplace. For abundant clarity, the Company does not provide any services to users other than providing the Marketplace as a platform to transact at their own cost and risk, and other services as may be specifically notified in writing.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'The Company is not and cannot be a party to any transaction between you and the third party sellers, or have any control, involvement or influence over the products purchased by you from such third party sellers or the prices of such products charged by such third-party sellers. The Company therefore disclaims all warranties and liabilities associated with any products offered on the Marketplace.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),const SizedBox(height: 2),
              Text(
                'Services on the Marketplace are available to only select geographies in India, and are subject to restrictions based on business hours and days of third party sellers. Transactions through the Marketplace may be subject to a delivery charge where the minimum order value is not met. You will be informed of such delivery charges at the stage of check-out for a transaction through the Marketplace.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),const SizedBox(height: 2),
              Text(
                'Transactions through the Marketplace may be subject to a convenience & safety fee. You will be informed of such convenience & safety fee at the stage of check-out for a transaction through the Marketplace.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Eligibility',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Persons who are “incompetent to contract” within the meaning of the Indian Contract Act, 1872 including minors, undischarged insolvents etc. are not eligible to use/access the Marketplace. However, if you are a minor, i.e. under the age of 18 years, you may use/access the Marketplace under the supervision of an adult parent or legal guardian who agrees to be bound by these Terms of Use. You are however prohibited (even under provision) from purchasing any product(s) which is for adult consumption, the sale of which to minors is prohibited. The Marketplace is intended to be a platform for end-consumers desirous of purchasing product(s) for domestic self-consumption. If you are a retailer, institution, wholesaler or any other business user, you are not eligible to use the Marketplace to purchase products from third-party sellers, who have been granted access to the Marketplace to display and offer their products for sale through the Marketplace. The Company, in its sole discretion and without liability, reserves the right to terminate or refuse your registration, or refuse to permit use/access to the Marketplace, if: (i) it is discovered or brought to notice that you do not conform to the eligibility criteria, or (ii) the Company has reason to believe (including through evaluating usage patterns) that the eligibility criteria is not met/is violated by a user, or (iii) may breach the terms of this User Agreement. In order to determine compliance with eligibility criteria, the Company inter alia uses an algorithm and/or pre-determined criteria based technology and accordingly, from time to time, your usage may be restricted or blocked on account of overlap with such algorithms/predetermined criteria. In such cases, if you are a genuine domestic user of the Platform, please contact us for assistance.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Licence & Access',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'The Company grants you a limited sub-license to access and make personal use of the Marketplace, but not to download (other than page caching) or modify it, or any portion of it, except with express prior written consent of the Company. Such limited sublicense does not include/permit any resale or commercial use of the Marketplace or its contents; any collection and use of any product listings, descriptions, or prices; any derivative use of the Marketplace or its contents; any downloading or copying of information for the benefit of another third party; or any use of data mining, robots, or similar data gathering and extraction tools.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'The Marketplace or any portion of the Marketplace may not be reproduced, duplicated, copied, sold, resold, visited, or otherwise exploited for any commercial purpose without express prior written consent of the Company You may not frame or utilize framing techniques to enclose any trademark, logo, or other proprietary information (including images, text, page layout, or form) of the Marketplace or of the Company and/or its affiliates without the express prior written consent of the Company. You may not use any meta tags or any other “hidden text” utilizing the Company’s name or trademarks without the express prior written consent of the Company.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'You shall not attempt to gain unauthorized access to any portion or feature of the Marketplace, or any other systems or networks connected to the Marketplace or to any server, computer, network, or to any of the services offered on or through the Marketplace, by hacking, ‘password mining’ or any other illegitimate means.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'You hereby agree and undertake not to host, display, upload, modify, publish, transmit, update or share any information which:',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'Belongs to another person and to which you do not have any right; Is grossly harmful, harassing, blasphemous, defamatory, obscene, pornographic, paedophilic, libelous, invasive of another’s privacy, hateful, or racially, ethnically objectionable, disparaging, relating or encouraging money laundering or gambling, or otherwise unlawful in any manner whatever; Harms minors in any way;',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'Infringes any patent, trademark, copyright or another proprietary/intellectual property right;',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'Violates any law for the time being in force;',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Deceives or misleads the addressee about the origin of such messages communicates any information which is grossly offensive or menacing in nature; Contains software viruses or any other computer code, files or programs designed to interrupt, destroy or limit the functionality of any computer resource; Threatens the unity, integrity, defence, security or sovereignty of India, friendly relations with foreign states, or public order or causes incitement to the commission of any cognizable offense or prevents investigation of any offense or is insulting any other nation; Is misleading or known to be false in any way.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Any unauthorized use shall automatically terminate the permission or sub-license granted by the Company.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Account & Registration Obligations',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'All users must register and log in for placing orders on the Marketplace. You must keep your account and registration details current and correct for all communications related to your purchases from the Marketplace. By agreeing to the Terms of Use, you agree to receive promotional or transactional communication and newsletters from the Company and its partners. You can opt out from such communication and/or newsletters either by contacting the customer services team of Marketplace or by placing a request for the same.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'As part of the registration process on the Marketplace, the Company may collect the following personally identifiable information about you, including but not limited to name, email address, age, address, mobile phone number, and other contact details, demographic profile (like your age, gender, occupation, education, address etc.) and information about the pages on the Marketplace you visit/access, the links you click on the Marketplace, the number of times you access a particular page/feature and any such information. Information collected about you is subject to the privacy policy of the Company (http://claconew.sigmasoftwares.org//privacy), which is incorporated in these Terms of Use by reference.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pricing',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'The Company aims to ensure that prices of all products offered for sale are true and correct. However, from time to time, the prices of certain products may not be current or may be inaccurate on account of technical issues, typographical errors or incorrect product information provided to the Company by third-party sellers. In each such case, notwithstanding anything to the contrary, the Company reserves the right to cancel the order without any further liability.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Subject to the foregoing, the price mentioned at the time of ordering a product shall be the price charged at the time of delivery, provided that no product offered for sale on the Marketplace will be sold at a price higher than its MRP (maximum retail price).',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Advertising',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Some of the Services are supported by advertising revenue and may display advertisements and promotions. These advertisements may be targeted to the content of information stored on the Services, queries made through the Services or other information. The manner, mode and extent of advertising by Claco Store on the Services are subject to change without specific notice to you. In consideration for Claco Store granting you access to and use of the Services, you agree that Claco Store may place such advertising on the Services.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Part of the site may contain advertising information or promotional material or other material submitted to Claco Store by third parties or Customers. Responsibility for ensuring that material submitted for inclusion on the Marketplace and / or Claco Store Platform complies with applicable international and national law is exclusively on the party providing the information/material. Your correspondence or business dealings with, or participation in promotions of, advertisers other than Claco Store found on or through the Marketplace and / or Claco Store Platform, including payment and delivery of related goods or services, and any other terms, conditions, warranties or representations associated with such dealings, shall be solely between you and such advertiser. Claco Store will not be responsible or liable for any error or omission, inaccuracy in advertising material or any loss or damage of any sort incurred as a result of any such dealings or as a result of the presence of such other advertiser(s) on the Marketplace and / or Claco Store Platform.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'For any information related to a charitable campaign ("Charitable Campaign") sent to Customers and/or displayed on the Marketplace and / or Claco Store Platform where Customers have an option to donate money by way of (a) payment on a third party website; or (b) depositing funds to a third party bank account, Claco Store is not involved in any manner in the collection or utilisation of funds collected pursuant to the Charitable Campaign. Claco Store does not accept any responsibility or liability for the accuracy, completeness, legality or reliability of any information related to the Charitable Campaign. Information related to the Charitable Campaign is displayed for informational purposes only and Customers are advised to do an independent verification before taking any action in this regard.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reviews, Feedback, Submissions',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'All reviews, comments, feedback, suggestions, ideas, and other submissions disclosed, submitted or offered on the Marketplace or otherwise disclosed, submitted or offered in connection with use of the Marketplace (collectively, the Comments) shall be and remain the property of the Company. Such disclosure, submission or offer of any Comments shall constitute an assignment to the Company of all worldwide rights, titles and interests in all copyrights and other intellectual properties in the Comments. Thus, the Company shall exclusively own all such rights, titles and interests in the Comments and shall not be limited in any way in its use, commercial or otherwise.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'The Company will be entitled to use, reproduce, disclose, modify, adapt, create derivative works from any Comments, and publish, display and distribute any Comments submitted for any purpose whatsoever without restriction and without compensating the user in any way. The Company is and shall be under no obligation to:',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 2),
              RichText(
                text:  TextSpan(
                  children: [
                    const TextSpan(
                      text: '(i)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' maintain any Comments in confidence; or',
                      style: TextStyle( color: Colors.grey[40],
                          fontSize: 12
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text:  TextSpan(
                  children: [
                    const TextSpan(
                      text: '(ii)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '  pay compensation for any Comments; or',
                      style: TextStyle( color: Colors.grey[40],
                          fontSize: 12
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text:  TextSpan(
                  children: [
                    const TextSpan(
                      text: '(iii)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' respond to any Comments.',
                      style: TextStyle( color: Colors.grey[40],
                          fontSize: 12
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'You agree that any Comments submitted by you on the Marketplace will not violate the Terms of Use or any right of any third party, including copyright, trademark, privacy or other personal or proprietary right(s), and will not cause injury to any person or entity. You further agree that no Comments submitted by you on the Marketplace will be or contain libellous or otherwise unlawful, threatening, abusive or obscene material, or contain software viruses, political campaigning, commercial solicitation, chain letters, mass mails or any form of ‘spam’. The Company does reserve the right (but assumes no obligation) to monitor, edit and/or remove any Comments submitted on the Marketplace. You hereby grant the Company the right to use names that you submit in connection with any Comments. You agree not to use a false email address, impersonate any person or entity, or otherwise mislead as to the origin of any Comments you submit. You are, and shall remain, responsible for the content of any Comments you make and you agree to indemnify the Company and its affiliates against all claims, loss and liabilities resulting from any Comments you submit.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Further, any reliance placed on Comments available on the Marketplace from a third party shall be at your sole risk and expense.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Copyright & Trademark',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'The Company, its suppliers and licensors expressly reserve all intellectual property rights in all text, programs, products, processes, technology, images, content and other materials which appear on the Marketplace. Access to or use of the Marketplace does not confer and should not be considered as conferring upon anyone any license, sub-license to the Company’s intellectual property rights. All rights, including copyright, in and to the Marketplace are owned by or licensed to the Company. Any use of the Marketplace or its contents, including copying or storing it or them in whole or part is prohibited without the express prior written consent of the Company',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'You may not modify, distribute or re-post anything on the Marketplace for any purpose. The names and logos and all related product and service names, design marks and slogans are the trademarks/service marks of the Company, its affiliates, its partners or its suppliers/service providers. All other marks are the property of their respective owners. No trademark or service mark license is granted in connection with the materials contained on the Marketplace. Access to or use of the Marketplace does not authorize anyone to use any name, logo or mark in any manner. References on the Marketplace to any names, marks, products or services of third parties or hypertext links to third party sites or information are provided solely as a convenience to you after having express consent from third parties and do not in any way constitute or imply the Company’s endorsement, sponsorship or recommendation of the third party, the information, its product or services The Company is not responsible for the content of any third-party sites and does not make any representations regarding the content or accuracy of material on such sites. If you decide to access a link of any third-party websites, you do so entirely at your own risk and expense.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Objectionable Material',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'You understand that by using the Marketplace or any services provided on the Marketplace, you may encounter content that may be deemed by some to be offensive, indecent, or objectionable, which content may or may not be identified as such. You agree to use the Marketplace and any service at your sole risk and that to the fullest extent permitted under applicable law, the Company and its affiliates shall have no liability to you for any content that may be deemed offensive, indecent, or objectionable to you.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Indemnity',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'You agree to defend, indemnify and hold harmless the Company, its employees, directors, officers, agents and their successors and assigns from and against any and all claims, liabilities, damages, losses, costs and expenses, including attorney’s fees, caused by or arising out of claims based upon a breach of any warranty, representation or undertaking in this User Agreement, or arising out of a violation of any applicable law (including but not limited in relation to intellectual property rights, payment of statutory dues and taxes, claims of libel, defamation, violation of rights of privacy or publicity, loss of service by other subscribers and infringement of intellectual property or other rights). This clause shall survive the expiry or termination of this User Agreement.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Limitation Of Liability',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'The aggregate liability of the Company, if any, that is established and ordered by a court of competent jurisdiction pursuant to a claim, shall in no event extend beyond refund of the money charged from a user for purchases made pursuant to an order under which such liability has arisen and been established. It is acknowledged and agreed that notwithstanding anything to the contrary, the Company shall not be liable, under any circumstances, whether in contract or in tort, for any indirect, special, consequential or incidental losses or damages, including on grounds of loss of profit, loss of reputation or loss of business opportunities.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Termination',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'This User Agreement is effective unless and until terminated, either by you or by the Company. You may terminate this User Agreement at any time, provided that you discontinue any further use of the Marketplace. The Company may terminate this User Agreement at any time and may do so immediately without notice, and accordingly deny you access to the Marketplace.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'The Company’s right to any comments and to be indemnified pursuant to the terms hereof, shall survive any termination of this User Agreement. Any such termination of the User Agreement shall not cancel your obligation to pay for product(s) already ordered from the Marketplace or affect any liability that may have arisen under the User Agreement prior to the date of termination.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Governing & Jurisdiction',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'The User Agreement shall be governed by and construed in accordance with the laws of India, without giving effect to the principles of conflict of laws thereunder. Any dispute or difference, whether on the interpretation or otherwise, in respect of any terms hereof shall be referred to an independent arbitrator to be appointed by the Company. Such an arbitrator’s decision shall be final and binding on the parties. The arbitration shall be in accordance with the Arbitration and Conciliation Act, 1996, as amended or replaced from time to time. The seat of arbitration shall be Lucknow and the language of the arbitration shall be English/Hindi. Subject to the aforesaid, the Courts at Lucknow shall have exclusive jurisdiction over any proceedings arising in respect of the User Agreement.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Communication With The Company',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text:  TextSpan(
                  children: [
                    TextSpan(
                      text: 'If you need to correct or update any information you have provided, you can conveniently do so online through our website. Alternatively, you can reach out to our company for assistance with updating or correcting your information by sending an email to:',
                      style: TextStyle( color: Colors.grey[40],
                          fontSize: 12
                      ),
                    ),
                    const TextSpan(
                      text: ' contact@claco.in',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.pink),
                    ),
                  ],
                ),
              ),
              RichText(
                text:  TextSpan(
                  children: [
                    TextSpan(
                      text: 'In case you experience any loss of access to our website, please do not hesitate to contact us by sending an email to:',
                      style: TextStyle( color: Colors.grey[40],
                          fontSize: 12
                      ),
                    ),
                    const TextSpan(
                      text: ' contact@claco.in',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.pink),
                    ),
                    TextSpan(
                      text: ' We are here to help resolve any issues you may encounter. You',
                      style: TextStyle( color: Colors.grey[40],
                          fontSize: 12
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Delivery',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '1. Every store has its own delivery charges. The delivery charges are mentioned on the app and web at the checkout page.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '2. The delivery timings are different for different cities and localities. In some locations, our deliveries begin from 8 AM and the last delivery is completed by 11 PM.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ), const SizedBox(height: 4),
              Text(
                '3. our deliveries are honoured within the 2 to 4 hours after placing the order. On rare occasions, due to unforeseen circumstances, your order might be delayed. In case of imminent delay, our customer support executive will keep you updated about the delivery time of your order.',
                style: TextStyle(
                    color: Colors.grey[40],
                    fontSize: 12
                ),
              ),
              // Add more text sections as needed
            ],
          ),
        ),
      ),
    );
  }
}
