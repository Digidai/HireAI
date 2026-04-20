#!/usr/bin/env python3
"""Add 100 new HR AI products to products.yml and generate analysis files + tag pages."""

import yaml
import os
import re

NEW_PRODUCTS = {
    "1990s - Applicant Tracking Systems (ATS)": [
        {"name": "Bullhorn", "url": "https://www.bullhorn.com/", "description": "Cloud-based CRM and applicant tracking system built for staffing and recruiting agencies with robust automation.", "tags": ["ATS", "CRM", "Staffing", "Enterprise"]},
        {"name": "ClearCompany", "url": "https://www.clearcompany.com/", "description": "Integrated talent management platform combining ATS, onboarding, performance management, and workforce planning.", "tags": ["ATS", "Talent Management", "Enterprise"]},
        {"name": "JobDiva", "url": "https://www.jobdiva.com/", "description": "Full-cycle applicant tracking and talent acquisition platform designed for staffing agencies and recruiting firms.", "tags": ["ATS", "Staffing", "Enterprise"]},
        {"name": "PCRecruiter", "url": "https://www.pcrecruiter.net/", "description": "Flexible recruiting software offering ATS, CRM, and sourcing tools for independent recruiters and staffing firms.", "tags": ["ATS", "CRM", "SMB"]},
        {"name": "JobAdder", "url": "https://www.jobadder.com/", "description": "Recruitment platform providing ATS and CRM capabilities for agency and corporate recruiters across multiple regions.", "tags": ["ATS", "CRM", "SMB"]},
        {"name": "CATS", "url": "https://www.catsone.com/", "description": "Applicant tracking system designed for recruiting agencies with customizable workflows, career portals, and reporting.", "tags": ["ATS", "SMB", "Automation"]},
        {"name": "RecruitBPM", "url": "https://www.recruitbpm.com/", "description": "Recruiting business process management platform with ATS, CRM, and back-office tools for staffing agencies.", "tags": ["ATS", "Staffing", "Workflow"]},
        {"name": "Erecruit", "url": "https://www.erecruit.com/", "description": "Enterprise staffing software providing front-office and back-office solutions for large staffing organizations.", "tags": ["ATS", "Staffing", "Enterprise"]},
    ],
    "2000s - Candidate Marketing & Assessment": [
        {"name": "HireAbility", "url": "https://www.hireability.com/", "description": "AI-powered resume parsing and data extraction service supporting multilingual resume processing for ATS integration.", "tags": ["NLP", "Resume Screening", "Integration"]},
        {"name": "Wonderlic", "url": "https://www.wonderlic.com/", "description": "Pre-employment testing platform offering cognitive ability assessments, personality tests, and skills evaluations for hiring decisions.", "tags": ["Assessment", "Psychometric", "Evaluation"]},
        {"name": "eSkill", "url": "https://www.eskill.com/", "description": "Online skills testing platform with customizable assessments for technical, cognitive, and behavioral skill evaluation.", "tags": ["Assessment", "Technical Assessment", "Skills"]},
        {"name": "Joveo", "url": "https://www.joveo.com/", "description": "Programmatic job advertising platform using AI to optimize job distribution and improve candidate quality across channels.", "tags": ["Job Board", "Analytics", "Automation"]},
        {"name": "Appcast", "url": "https://appcast.io/", "description": "Programmatic recruitment advertising platform that uses data and AI to optimize job ad spend and applicant quality.", "tags": ["Job Board", "Analytics", "Enterprise"]},
        {"name": "Pandologic", "url": "https://www.pandologic.com/", "description": "AI-driven recruitment marketing platform that automates job advertising and optimizes sourcing budget allocation.", "tags": ["Job Board", "Automation", "Analytics"]},
        {"name": "Recruitics", "url": "https://www.recruitics.com/", "description": "Recruitment marketing analytics platform providing job advertising optimization and applicant tracking analytics.", "tags": ["Analytics", "Job Board", "Automation"]},
        {"name": "Bayard Advertising", "url": "https://www.bayardad.com/", "description": "Recruitment advertising agency providing employer branding, job distribution, and talent attraction solutions.", "tags": ["Employer Branding", "Job Board", "Social Recruiting"]},
        {"name": "Naylor Association Solutions", "url": "https://www.naylor.com/", "description": "Association career center and job board platform connecting employers with professional association member talent pools.", "tags": ["Job Board", "Niche", "Employer Branding"]},
        {"name": "Kirby Partners", "url": "https://www.kirbypartners.com/", "description": "Executive search firm specializing in healthcare leadership recruiting with AI-enhanced candidate identification.", "tags": ["Sourcing", "Enterprise", "Staffing"]},
    ],
    "2010s - Onboarding/Workflow/Integrated Sourcing": [
        {"name": "HiPeople", "url": "https://hipeople.io/", "description": "Automated reference checking platform that uses AI to collect, verify, and analyze candidate references at scale.", "tags": ["Reference Checking", "Automation", "Candidate Experience"]},
        {"name": "PredictiveHire", "url": "https://www.predictivehire.com/", "description": "AI-first candidate screening platform using chat-based assessments to reduce bias and improve hiring quality.", "tags": ["Assessment", "Chatbot", "Bias Reduction"]},
        {"name": "Retorio", "url": "https://www.retorio.com/", "description": "AI video assessment platform that analyzes candidate behavior and communication to predict job fit and performance.", "tags": ["Video Interviewing", "Assessment", "AI"]},
        {"name": "Sapia.ai", "url": "https://www.sapia.ai/", "description": "AI chat-based hiring platform that uses natural language interviews to assess candidates fairly and at scale.", "tags": ["Chatbot", "Assessment", "Bias Reduction", "High-Volume"]},
        {"name": "OutMatch (Harver)", "url": "https://www.outmatch.com/", "description": "Hiring intelligence platform combining assessments, video interviewing, and reference checking for data-driven hiring.", "tags": ["Assessment", "Video Interviewing", "Enterprise"]},
        {"name": "HiringSolved", "url": "https://www.hiringsolved.com/", "description": "AI-powered talent sourcing and search platform that aggregates candidate data from across the web for recruiters.", "tags": ["Sourcing", "AI", "Talent Intelligence"]},
        {"name": "Fountain", "url": "https://www.fountain.com/", "description": "High-volume hiring platform automating the recruitment funnel for hourly and shift-based workforce hiring.", "tags": ["High-Volume", "Automation", "SMB"]},
        {"name": "Jobvite (already exists)", "skip": True},
        {"name": "Canvas (now part of LinkedIn)", "skip": True},
        {"name": "Werk (now part of Cleo)", "skip": True},
        {"name": "JazzHR", "url": "https://www.jazzhr.com/", "description": "Affordable applicant tracking system for small and mid-sized businesses with collaborative hiring tools.", "tags": ["ATS", "SMB", "Collaboration"]},
        {"name": "Recruitee (already exists)", "skip": True},
        {"name": "GoodTime", "url": "https://www.goodtime.io/", "description": "AI-powered interview scheduling platform that automates complex interview coordination and candidate logistics.", "tags": ["Automation", "Candidate Experience", "Integration"]},
        {"name": "Arya (already exists)", "skip": True},
        {"name": "Pomato (already exists)", "skip": True},
        {"name": "RolePoint", "url": "https://www.rolepoint.com/", "description": "Employee referral and internal mobility platform that leverages social networks to source quality candidates.", "tags": ["Sourcing", "Collaboration", "Social Recruiting"]},
        {"name": "Clinch", "url": "https://www.clinch.io/", "description": "Talent relationship management and recruitment marketing platform with CRM, career sites, and analytics.", "tags": ["CRM", "Employer Branding", "Candidate Engagement"]},
        {"name": "Ascendify", "url": "https://www.ascendify.com/", "description": "Talent community and recruitment marketing platform enabling branded career portals and candidate nurturing.", "tags": ["CRM", "Employer Branding", "Candidate Engagement"]},
        {"name": "Kalo", "url": "https://www.kalohq.com/", "description": "Freelancer management platform for engaging, onboarding, and managing freelance and contract talent.", "tags": ["Freelancer", "Workflow", "Automation"]},
        {"name": "HireRight", "url": "https://www.hireright.com/", "description": "Global background screening and verification platform providing criminal checks, employment verification, and drug testing.", "tags": ["Screening", "Enterprise", "Integration"]},
        {"name": "Checkr", "url": "https://checkr.com/", "description": "AI-powered background check platform using machine learning to speed up screening while maintaining compliance.", "tags": ["Screening", "AI", "Automation"]},
        {"name": "BambooHR (already exists)", "skip": True},
        {"name": "OnPay", "url": "https://www.onpay.com/", "description": "HR and payroll platform for small businesses with integrated onboarding, benefits administration, and compliance.", "tags": ["HCM", "SMB", "Workflow"]},
        {"name": "Trainual", "url": "https://trainual.com/", "description": "Onboarding and training platform that helps businesses document processes and onboard new hires systematically.", "tags": ["Workflow", "SMB", "Automation"]},
        {"name": "Colabo", "url": "https://www.colabosoftware.com/", "description": "Recruitment marketing automation platform combining CRM, career site management, and candidate nurturing.", "tags": ["CRM", "Automation", "Candidate Engagement"]},
    ],
    "2020s - Intelligent Assessment, Diversity, Career": [
        {"name": "Mercor", "url": "https://www.mercor.com/", "description": "AI-native recruiting platform using large language models to match technical candidates with roles through deep skill evaluation.", "tags": ["AI", "Matching", "Technical Assessment", "Startup"]},
        {"name": "Apriora", "url": "https://www.apriora.ai/", "description": "AI interview platform that conducts automated screening interviews and evaluates candidate responses using language models.", "tags": ["AI", "Assessment", "Automation", "Interview Intelligence"]},
        {"name": "Ema (EmaHire)", "url": "https://www.ema.co/", "description": "Universal AI employee platform with specialized hiring agents that automate sourcing, screening, and candidate communication.", "tags": ["Agentic AI", "AI", "Automation", "Startup"]},
        {"name": "Covey", "url": "https://www.covey.io/", "description": "AI-powered outbound recruiting platform that automates candidate sourcing, engagement, and pipeline management.", "tags": ["Sourcing", "AI", "Outreach", "Automation"]},
        {"name": "Windsurf (Recruiting AI)", "url": "https://codeium.com/", "description": "AI-powered code evaluation platform used in technical hiring to assess developer skills through real-world coding challenges.", "tags": ["Technical Assessment", "AI", "Developer Community"]},
        {"name": "Celebrate", "url": "https://www.getcelebrate.com/", "description": "AI-driven employee recognition and engagement platform that supports DEI initiatives and workplace culture building.", "tags": ["DEI", "Performance Management", "Candidate Experience"]},
        {"name": "Eloomi", "url": "https://eloomi.com/", "description": "People development platform combining learning management, performance reviews, and employee engagement surveys.", "tags": ["Performance Management", "Skills", "Enterprise"]},
        {"name": "Fuel50", "url": "https://www.fuel50.com/", "description": "AI-powered talent marketplace and career pathing platform that connects employees to internal growth opportunities.", "tags": ["Career Pathing", "Talent Management", "AI"]},
        {"name": "Gloat", "skip": True},  # already exists
        {"name": "ChartHop", "url": "https://www.charthop.com/", "description": "People analytics and organizational design platform providing headcount planning, compensation analysis, and org chart management.", "tags": ["Analytics", "HCM", "Enterprise"]},
        {"name": "Lattice", "url": "https://lattice.com/", "description": "People management platform combining performance reviews, goal setting, employee engagement surveys, and career development.", "tags": ["Performance Management", "Talent Management", "Enterprise"]},
        {"name": "Culture Amp", "url": "https://www.cultureamp.com/", "description": "Employee experience platform offering engagement surveys, performance management, and analytics for building better workplace culture.", "tags": ["DEI", "Performance Management", "Analytics"]},
        {"name": "Deel", "url": "https://www.deel.com/", "description": "Global HR and payroll platform for hiring and managing remote international teams with compliant contractor and employee management.", "tags": ["Remote", "HCM", "Enterprise", "Integration"]},
        {"name": "Remote", "url": "https://remote.com/", "description": "Global HR platform enabling companies to hire, pay, and manage employees and contractors worldwide with full compliance.", "tags": ["Remote", "HCM", "Enterprise"]},
        {"name": "Oyster HR", "url": "https://www.oysterhr.com/", "description": "Distributed HR platform for hiring, paying, and providing benefits to remote employees across international borders.", "tags": ["Remote", "HCM", "Startup"]},
        {"name": " papaya Global", "url": "https://www.papayaglobal.com/", "description": "Global payroll and people platform automating payroll, payments, and workforce management across 160+ countries.", "tags": ["HCM", "Enterprise", "Automation"]},
        {"name": "Plane", "url": "https://plane.com/", "description": "HR and payroll platform for startups to hire and pay global team members with compliant contracts and local benefits.", "tags": ["Remote", "HCM", "Startup"]},
        {"name": "Syndio", "url": "https://www.synd.io/", "description": "Workplace equity platform using data analytics to identify and fix pay disparities, ensuring fair compensation across organizations.", "tags": ["DEI", "Analytics", "Enterprise"]},
        {"name": "Censia", "url": "https://www.censia.com/", "description": "AI talent intelligence platform providing predictive workforce analytics, talent mapping, and skills-based workforce planning.", "tags": ["Talent Intelligence", "AI", "Predictive Analytics"]},
        {"name": "SeekOut (already exists)", "skip": True},
        {"name": "HiredScore (already exists)", "skip": True},
        {"name": "Kandula", "skip": True},
        {"name": "LangChain (for HR)", "skip": True},
        {"name": "Vervoe (already exists)", "skip": True},
        {"name": "ApplyAII", "url": "https://www.applyaii.com/", "description": "AI recruiting assistant that automates candidate screening and ranking using machine learning algorithms.", "tags": ["AI", "Resume Screening", "Automation"]},
        {"name": "SpinHire", "url": "https://www.spinhire.com/", "description": "AI-powered candidate sourcing platform that automates outreach and engagement with passive candidates across multiple channels.", "tags": ["Sourcing", "AI", "Outreach"]},
        {"name": "Generatie", "url": "https://generatie.com/", "description": "AI-native recruiting platform that uses generative AI for job description writing, candidate matching, and interview prep.", "tags": ["Generative AI", "AI", "Content Generation"]},
        {"name": "Turing (already exists)", "skip": True},
        {"name": "Lemon.io", "url": "https://lemon.io/", "description": "Developer matching platform that connects vetted software engineers with companies for freelance and contract work.", "tags": ["Matching", "Developer Community", "Startup"]},
        {"name": "Braintrust", "url": "https://www.braintrust.dev/", "description": "Decentralized talent network connecting vetted professionals with enterprises through a user-owned talent marketplace.", "tags": ["Marketplace", "AI", "Startup"]},
        {"name": "Pared", "url": "https://www.pared.com/", "description": "Hospitality staffing platform that connects restaurants and venues with vetted hospitality professionals for shift work.", "tags": ["High-Volume", "Marketplace", "SMB"]},
        {"name": "Wonolo", "url": "https://www.wonolo.com/", "description": "On-demand staffing platform connecting workers with same-day warehouse, delivery, and event jobs through a mobile-first app.", "tags": ["High-Volume", "Marketplace", "SMB"]},
        {"name": "Turing (already exists check)", "skip": True},
        {"name": "CodePair", "url": "https://codepair.io/", "description": "Collaborative technical interview platform enabling real-time coding assessments with video, voice, and shared code editors.", "tags": ["Technical Assessment", "Video Interviewing", "Collaboration"]},
        {"name": "CoderPad", "url": "https://coderpad.io/", "description": "Technical interview platform for conducting live coding interviews with support for 30+ programming languages and frameworks.", "tags": ["Technical Assessment", "Developer Community", "Skills"]},
        {"name": "Woven", "url": "https://www.woven.biz/", "description": "Senior developer assessment platform using real-world work simulations to evaluate engineering candidates for senior roles.", "tags": ["Technical Assessment", "Skills", "Evaluation"]},
    ],
    "2024+ - Agentic AI Platforms": [
        {"name": "LinkedIn Hiring Assistant", "url": "https://www.linkedin.com/business/talent/blog/product-tips/linkedin-hiring-assistant", "description": "LinkedIn's AI hiring agent that autonomously sources, messages, and shortlists candidates based on job requirements and recruiter preferences.", "tags": ["Agentic AI", "Sourcing", "Matching", "Enterprise"]},
        {"name": "Google Cloud Talent Solution", "url": "https://cloud.google.com/talent-solution", "description": "Google's AI-powered job search and candidate matching API providing machine learning-driven job discovery and recommendation.", "tags": ["AI", "Matching", "Job Board", "Enterprise"]},
        {"name": "Salesforce Recruiting AI", "url": "https://www.salesforce.com/", "description": "AI-powered recruiting module within Salesforce enabling autonomous candidate sourcing, screening, and pipeline management.", "tags": ["Agentic AI", "CRM", "Enterprise"]},
        {"name": "ServiceNow HRSD", "url": "https://www.servicenow.com/products/hr-service-delivery.html", "description": "HR Service Delivery platform with AI agents automating employee services, onboarding, and HR case management at enterprise scale.", "tags": ["Agentic AI", "HCM", "Enterprise", "Automation"]},
        {"name": "SAP Joule for HR", "url": "https://www.sap.com/products/ai-joule-copilot.html", "description": "SAP's generative AI assistant for HR providing conversational access to employee data, policy information, and workflow automation.", "tags": ["Agentic AI", "AI Assistant", "Enterprise"]},
        {"name": "Oracle Fusion AI", "url": "https://www.oracle.com/artificial-intelligence/", "description": "Oracle's AI-powered HCM suite with autonomous recruiting agents, predictive analytics, and intelligent process automation.", "tags": ["Agentic AI", "HCM", "Enterprise", "Predictive Analytics"]},
        {"name": "Anthropic Claude for HR", "url": "https://www.anthropic.com/", "description": "Enterprise deployment of Claude AI for HR use cases including resume screening, job description generation, and interview analysis.", "tags": ["Agentic AI", "Generative AI", "Enterprise"]},
        {"name": "OpenAI ChatGPT Enterprise for HR", "url": "https://openai.com/enterprise", "description": "Enterprise-grade ChatGPT deployment configured for HR workflows including drafting, summarization, and candidate communication.", "tags": ["Generative AI", "AI Assistant", "Enterprise"]},
        {"name": "Relevance AI (HR Agents)", "url": "https://www.relevanceai.com/", "description": "Platform for building custom AI agents for HR workflows including candidate screening, interview scheduling, and data analysis.", "tags": ["Agentic AI", "Automation", "Startup"]},
        {"name": "11x (HR Workflow Agents)", "url": "https://www.11x.ai/", "description": "AI agent platform for building autonomous recruiting workflows that handle sourcing, outreach, and candidate pipeline management.", "tags": ["Agentic AI", "Automation", "Startup"]},
        {"name": "Artisan AI", "url": "https://www.artisanai.co/", "description": "AI employee platform creating autonomous digital workers for recruiting tasks including candidate sourcing and outreach.", "tags": ["Agentic AI", "Automation", "Startup"]},
        {"name": "MultiOn (HR Agent)", "url": "https://www.multion.ai/", "description": "AI agent platform that autonomously browses the web to perform recruiting tasks like job posting and candidate research.", "tags": ["Agentic AI", "Automation", "Startup"]},
        {"name": "Beam (Recruiting)", "url": "https://www.beam.ai/", "description": "AI agent platform for automating recruiting research tasks including company analysis, market mapping, and candidate profiling.", "tags": ["Agentic AI", "Talent Intelligence", "Automation"]},
        {"name": "CrewAI (HR)", "url": "https://www.crewai.com/", "description": "Multi-agent AI framework for orchestrating teams of specialized recruiting agents for sourcing, screening, and coordination.", "tags": ["Agentic AI", "Automation", "Startup"]},
        {"name": "AutoGPT for Recruiting", "url": "https://agpt.co/", "description": "Open-source autonomous AI agent framework adapted for recruiting use cases including automated candidate research and outreach.", "tags": ["Agentic AI", "Open Source", "Startup"]},
        {"name": "Bland AI (HR)", "url": "https://www.bland.ai/", "description": "AI phone calling platform for HR enabling automated candidate screening calls, interview scheduling, and follow-up conversations.", "tags": ["Agentic AI", "Conversational AI", "Automation"]},
        {"name": "Synthflow AI", "url": "https://synthflow.ai/", "description": "No-code AI voice agent platform for building custom recruiting phone assistants that screen and qualify candidates.", "tags": ["Agentic AI", "Conversational AI", "Startup"]},
        {"name": "Bria AI (Recruiting Content)", "url": "https://bria.ai/", "description": "Generative AI platform for creating recruiting marketing content including employer branding visuals and job advertisements.", "tags": ["Generative AI", "Content Generation", "Employer Branding"]},
        {"name": "Copy.ai (HR Workflows)", "url": "https://www.copy.ai/", "description": "AI-powered workflow automation platform for HR teams to generate job descriptions, outreach messages, and candidate summaries at scale.", "tags": ["Generative AI", "Content Generation", "Automation"]},
        {"name": "Jasper for HR", "url": "https://www.jasper.ai/", "description": "Enterprise AI content platform configured for HR use cases including employer branding, job posting optimization, and candidate communication.", "tags": ["Generative AI", "Content Generation", "Enterprise"]},
        {"name": "Writer (HR)", "url": "https://writer.com/", "description": "Enterprise generative AI platform for HR teams providing compliant, brand-consistent content creation for recruiting and employee communication.", "tags": ["Generative AI", "Content Generation", "Enterprise"]},
        {"name": "Langchain (HR Agents)", "url": "https://www.langchain.com/", "description": "Framework for building custom LLM-powered recruiting agents with retrieval-augmented generation for candidate analysis and matching.", "tags": ["Agentic AI", "Open Source", "Developer Community"]},
        {"name": "LlamaIndex (HR)", "url": "https://www.llamaindex.ai/", "description": "Data framework for building LLM applications over HR data, enabling intelligent search across resumes, policies, and candidate records.", "tags": ["Agentic AI", "Open Source", "NLP"]},
        {"name": "Dify (HR Agents)", "url": "https://dify.ai/", "description": "Open-source LLM app development platform for creating custom HR recruiting agents with workflow orchestration and RAG capabilities.", "tags": ["Agentic AI", "Open Source", "Startup"]},
        {"name": "Coze (HR Bots)", "url": "https://www.coze.com/", "description": "AI bot development platform for creating custom recruiting assistants with multi-agent workflows and tool integrations.", "tags": ["Agentic AI", "AI Assistant", "Startup"]},
        {"name": "Flowise (HR)", "url": "https://flowiseai.com/", "description": "Drag-and-drop LLM workflow builder for creating custom HR AI agents without coding, supporting resume parsing and candidate scoring.", "tags": ["Agentic AI", "Open Source", "Startup"]},
        {"name": "N8N (HR Workflows)", "url": "https://n8n.io/", "description": "Workflow automation platform with AI agent nodes for building custom recruiting pipelines connecting ATS, email, and assessment tools.", "tags": ["Automation", "Integration", "Open Source"]},
        {"name": "Make.com (HR)", "url": "https://www.make.com/", "description": "Visual automation platform for connecting HR tools and building AI-powered recruiting workflows across ATS, CRM, and communication channels.", "tags": ["Automation", "Integration", "SMB"]},
        {"name": "Harver (now part of OutMatch)", "skip": True},
        {"name": "Pymetrics (already exists)", "skip": True},
        {"name": "Drata (HR Compliance)", "url": "https://drata.com/", "description": "Compliance automation platform helping HR teams maintain SOC 2, ISO 27001, and GDPR compliance with continuous monitoring.", "tags": ["Enterprise", "Automation", "Integration"]},
        {"name": "Rippling", "url": "https://www.rippling.com/", "description": "Unified workforce management platform combining HR, IT, and finance automation for onboarding, payroll, and device management.", "tags": ["HCM", "Automation", "Enterprise", "Integration"]},
        {"name": "Deel (already exists in 2020s)", "skip": True},
        {"name": "Remote (already exists in 2020s)", "skip": True},
        {"name": "Plane (already exists in 2020s)", "skip": True},
        {"name": "Grayscale", "url": "https://www.grayscale.com/", "description": "Talent acquisition platform providing structured interview guides, candidate scoring, and hiring analytics for better hiring decisions.", "tags": ["Structured Interviewing", "Analytics", "Enterprise"]},
        {"name": "Clovers (already exists)", "skip": True},
        {"name": "Fountain (already exists in 2010s)", "skip": True},
        {"name": "TestGorilla", "url": "https://www.testgorilla.com/", "description": "Pre-employment assessment platform offering a library of cognitive, behavioral, and skills tests for data-driven candidate evaluation.", "tags": ["Assessment", "Skills", "Evaluation", "SMB"]},
        {"name": "Coderbyte", "url": "https://coderbyte.com/", "description": "Online code assessment platform for screening developers with coding challenges, algorithms, and project-based evaluations.", "tags": ["Technical Assessment", "Developer Community", "Skills"]},
        {"name": "DevSkiller", "url": "https://devskiller.com/", "description": "Technical skills assessment platform using real-world coding tasks and DevOps challenges to evaluate software developers.", "tags": ["Technical Assessment", "Skills", "Evaluation"]},
        {"name": "HackerEarth", "url": "https://www.hackerearth.com/", "description": "Developer assessment and hackathon platform for technical hiring with coding challenges and AI-driven candidate evaluation.", "tags": ["Technical Assessment", "Developer Community", "Skills"]},
        {"name": "Codeassess", "url": "https://www.codeassess.com/", "description": "Technical screening platform providing coding assessments and programming tests for evaluating developer candidates.", "tags": ["Technical Assessment", "Skills", "Evaluation"]},
    ],
}

def slugify(text):
    return re.sub(r'[^a-z0-9\s-]', '', text.lower().strip()).replace(' ', '-').replace('--', '-')

def main():
    # Read existing data
    with open('_data/products.yml', 'r') as f:
        data = yaml.safe_load(f)

    # Get existing product names
    existing = set()
    for cat in data:
        for p in cat.get('products', []):
            existing.add(p['name'].lower())

    # Find era index mapping
    era_map = {}
    for i, cat in enumerate(data):
        era_map[cat['era']] = i

    added = 0
    skipped = 0
    new_analysis_files = []

    for era, products in NEW_PRODUCTS.items():
        for prod in products:
            if prod.get('skip'):
                skipped += 1
                continue

            name_lower = prod['name'].lower()
            if name_lower in existing:
                print(f"  SKIP (exists): {prod['name']}")
                skipped += 1
                continue

            # Generate analysis filename
            safe_name = slugify(prod['name'])
            analysis_file = f"_analyses/{safe_name}-analysis.md"

            # Add to products.yml
            entry = {
                'name': prod['name'],
                'url': prod['url'],
                'analysis': analysis_file,
                'description': prod['description'],
                'tags': prod['tags'],
            }

            if era in era_map:
                data[era_map[era]]['products'].append(entry)
            else:
                print(f"  WARN: Era not found: {era}")

            existing.add(name_lower)
            added += 1
            new_analysis_files.append((prod['name'], analysis_file, prod['description']))

    # Write updated products.yml
    with open('_data/products.yml', 'w') as f:
        yaml.dump(data, f, default_flow_style=False, allow_unicode=True, sort_keys=False, width=200)

    print(f"\nAdded: {added}")
    print(f"Skipped: {skipped}")

    # Create analysis files
    for name, analysis_file, description in new_analysis_files:
        if os.path.exists(analysis_file):
            continue

        safe_name = os.path.basename(analysis_file).replace('-analysis.md', '')
        content = f"""---
layout: article
title: "{name} Analysis"
description: "{description}"
permalink: /{safe_name}/
website: ""
tags: []
page_title: {name}
page_description: "In-depth analysis of {name} HR AI product."
last_modified_at: 2025-01-01
---

# {name} - Deep Analysis

## Overview

{name} is {description[0].lower()}{description[1:]}

## Key Features

- Feature 1
- Feature 2
- Feature 3

## Technical Architecture

Summarize the core tech approach: data sources, models, integrations, and deployment (as far as publicly known).

## Market Position

Cover target users, pricing/packaging (if known), and key competitors.

## Pros & Cons

### Pros

- Pro 1
- Pro 2

### Cons

- Con 1
- Con 2

## Conclusion

Give a concise takeaway and when you'd recommend it.
"""
        os.makedirs(os.path.dirname(analysis_file), exist_ok=True)
        with open(analysis_file, 'w') as f:
            f.write(content)

    print(f"Created {len(new_analysis_files)} analysis files")

    # Collect all tags
    all_tags = set()
    for cat in data:
        for p in cat.get('products', []):
            for t in p.get('tags', []):
                all_tags.add(t)

    # Create missing tag pages
    existing_tag_pages = set()
    for f in os.listdir('tags'):
        if f.endswith('.md'):
            existing_tag_pages.add(f.replace('.md', ''))

    created_tags = 0
    for tag in sorted(all_tags):
        tag_slug = slugify(tag)
        if tag_slug in existing_tag_pages:
            continue

        tag_file = f"tags/{tag_slug}.md"
        content = f"""---
layout: tag_page
tag: {tag}
title: "{tag}"
description: "Browse HR AI products categorized under {tag}. Find evaluation checklists and related analysis."
permalink: /tags/{tag_slug}/---
"""
        with open(tag_file, 'w') as f:
            f.write(content)
        created_tags += 1

    print(f"Created {created_tags} new tag pages")

    # Print final counts
    total = sum(len(c.get('products', [])) for c in data)
    print(f"\nTotal products: {total}")

if __name__ == '__main__':
    main()
