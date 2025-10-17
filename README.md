# Introduction

**GitBook Framework for AI Agent Vector Store Optimization**

***

## Overview

This GitBook structure contains the complete knowledge base for Dr. Berg Nutritionals' internal customer support operations. It has been specifically designed to optimize AI agent (Sharon) vector store retrieval while maintaining intuitive navigation for human customer service agents.

**Total Documents:** 7,275 Markdown files\
**Last Updated:** October 17, 2025\
**Version:** 1.1

***

## Structure

### 1.0 Core Principles and Philosophy

Foundational health philosophy and brand identity that underlies all Dr. Berg products and recommendations.

### 2.0 Customer Service and Operations

Complete operational knowledge including policies, SOPs, and agent resources.

* **2.1 Policies** - Customer-facing policies (refunds, shipping, etc.)
* **2.2 Standard Operating Procedures** - Step-by-step operational guides (1,352 SOPs)
* **2.3 Agent Resources** - Templates, scripts, and reference materials

### 3.0 Health and Nutrition Knowledge Base

Comprehensive educational content on Dr. Berg's health approach.

* **3.1 Ketogenic Diet (Healthy Keto)** - 1,014 articles on keto principles and implementation
* **3.2 Intermittent Fasting** - 790 articles on fasting protocols and benefits
* **3.3 Weight Loss and Fat Burning** - Placeholder for future content
* **3.4 Nutritional Science** - 3,395 articles on vitamins, minerals, and nutrition
* **3.5 Specific Health Topics** - Placeholder for future content
* **3.6 Dr. Berg YouTube Videos** - 609 video links with direct YouTube URLs

### 4.0 Product Information

Product catalog with detailed specifications and usage guidelines.

* **4.1 Product Catalog** - 116 product pages with descriptions and details

***

## For Customer Service Agents

### Quick Navigation

**Need a policy?** → Navigate to `2.0-Customer-Service-and-Operations/2.1-Policies/`

**Need an SOP?** → Navigate to `2.0-Customer-Service-and-Operations/2.2-Standard-Operating-Procedures-SOPs/`

**Health question?** → Navigate to `3.0-Health-and-Nutrition-Knowledge-Base/` and select the appropriate subcategory

**Dr. Berg video?** → Navigate to `3.0-Health-and-Nutrition-Knowledge-Base/3.6-Dr-Berg-YouTube-Videos/`

**Product information?** → Navigate to `4.0-Product-Information/4.1-Product-Catalog/`

### Using the Search Function

Use GitBook's search feature to quickly find information:

* Search for keywords related to your question
* Use quotation marks for exact phrases (e.g., "30-day guarantee")
* Filter by section using the category numbers (e.g., "2.1" for policies)

***

## For Developers and AI Engineers

### Vector Store Integration

This structure is optimized for vector embedding and retrieval. Each Markdown file represents a semantic unit suitable for:

* Direct embedding as a document chunk
* Further subdivision by H2 headings for finer-grained retrieval
* Metadata tagging using the file path and category structure

### Recommended Chunking Strategy

```python
# Example chunking approach
chunk_metadata = {
    "category": "2.0-Customer-Service-and-Operations",
    "subcategory": "2.1-Policies",
    "file_path": "2.0-Customer-Service-and-Operations/2.1-Policies/2.1.1-Refunds-and-Returns.md",
    "file_name": "2.1.1-Refunds-and-Returns.md",
    "chunk_id": "2.1.1-001"
}
```

### Citation Format

When the AI agent retrieves information, it should cite sources using this format:

```
According to document 2.1.1 (Refunds and Returns), [information here].

Source: 2.1.1-Refunds-and-Returns.md
```

### YouTube Video Linking

When recommending Dr. Berg videos, the AI can:

1. Search the 3.6-Dr-Berg-YouTube-Videos section for relevant topics
2. Provide the direct YouTube URL to the user
3. Cite the video title and link

Example:

```
For more information, watch Dr. Berg's video: "What is Healthy Keto?"
https://www.youtube.com/watch?v=...
```

***

## File Naming Convention

All files follow a consistent naming pattern:

* **Numbered prefixes** indicate hierarchical position (e.g., `2.1.1-`)
* **Descriptive names** use kebab-case (lowercase with hyphens)
* **Markdown extension** (.md) for all content files

Examples:

* `2.1.1-Refunds-and-Returns.md`
* `3.1-Ketogenic-Diet-Healthy-Keto/what-is-healthy-keto.md`

***

## Content Sources

This knowledge base consolidates information from:

* Internal training materials (Keto, Fasting, Nutrition)
* Standard Operating Procedures (SOPs)
* Customer service policies
* Product documentation
* Dr. Berg's health philosophy documents
* YouTube video index (609 videos)

All duplicate content has been identified and eliminated to maintain a single source of truth.

***

## Maintenance and Updates

To maintain this knowledge base:

1. **Adding new content:** Place in the appropriate category directory
2. **Updating existing content:** Edit the specific Markdown file
3. **Retiring content:** Move to an archive directory (not included in vector store)
4. **Version control:** Use Git to track all changes

***

## Support and Documentation

For complete implementation details, see:

* `GitBook_Implementation_Guide.md` - Comprehensive setup and optimization guide
* `gitbook_taxonomy.md` - Detailed taxonomy design rationale

***

**Maintained by:** Dr. Berg Nutritionals Support Team\
**Questions?** Contact your team lead or system administrator
