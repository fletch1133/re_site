<template>
  <div class="about">
    <section class="page-header">
      <div class="container">
        <h1 class="page-title">About</h1>
        <p class="page-subtitle">Professional Background & Expertise</p>
      </div>
    </section>

    <section class="content-section">
      <div class="container">
        <div class="intro-block">
          <h2 class="section-heading">Real Estate Development Professional</h2>
          <p class="lead-text">
            A dedicated real estate development professional with extensive experience in managing
            complex projects from conception to completion. Specializing in transforming strategic
            visions into successful, sustainable developments.
          </p>
        </div>

        <div class="content-grid">
          <div class="content-block">
            <h3 class="block-title">Expertise</h3>
            <p class="block-text">
              My expertise spans across residential, commercial, and mixed-use developments, with a proven
              track record of delivering projects on time and within budget while maintaining the highest
              standards of quality and sustainability.
            </p>
          </div>

          <div class="content-block">
            <h3 class="block-title">Approach</h3>
            <p class="block-text">
              I believe in creating community-focused developments that not only meet market
              demands but also contribute positively to the urban landscape. My approach combines thorough
              market research, innovative design thinking, and meticulous project execution.
            </p>
          </div>
        </div>

        <div class="competencies-section">
          <h3 class="section-heading">Core Competencies</h3>
          <div class="competencies-grid">
            <div class="competency-item">
              <div class="competency-icon">📊</div>
              <h4>Project Planning & Management</h4>
              <p>Strategic oversight from concept to completion</p>
            </div>
            <div class="competency-item">
              <div class="competency-icon">💰</div>
              <h4>Financial Analysis</h4>
              <p>Comprehensive feasibility studies and budgeting</p>
            </div>
            <div class="competency-item">
              <div class="competency-icon">🤝</div>
              <h4>Stakeholder Coordination</h4>
              <p>Effective communication across all parties</p>
            </div>
            <div class="competency-item">
              <div class="competency-icon">📋</div>
              <h4>Regulatory Compliance</h4>
              <p>Permitting and legal requirements management</p>
            </div>
            <div class="competency-item">
              <div class="competency-icon">🏗️</div>
              <h4>Construction Oversight</h4>
              <p>Quality control and timeline management</p>
            </div>
            <div class="competency-item">
              <div class="competency-icon">📈</div>
              <h4>Market Analysis</h4>
              <p>Strategic positioning and market research</p>
            </div>
          </div>
        </div>

        <div class="cta-block">
          <h3 class="cta-heading">View My Work</h3>
          <p class="cta-text">Explore detailed case studies and documentation of completed projects</p>
          <div class="cta-buttons">
            <router-link to="/projects" class="btn btn-primary">VIEW PROJECTS</router-link>
            <router-link to="/resume" class="btn btn-secondary">VIEW RESUME</router-link>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.about {
  width: 100%;
  background-color: #ffffff;
}

.container {
  max-width: 100%;
  margin: 0 auto;
  padding: 0 4rem;
}

.page-header {
  background-color: #f7fafc;
  padding: 4rem 0;
  border-bottom: 1px solid #e5e7eb;
}

.page-title {
  font-size: 3rem;
  font-weight: 700;
  margin-bottom: 1rem;
  color: #1a1a1a;
  letter-spacing: -1px;
  text-align: center;
}

.page-subtitle {
  font-size: 1.125rem;
  color: #4a5568;
  text-align: center;
}

.content-section {
  padding: 5rem 0 6rem;
}

.intro-block {
  max-width: 900px;
  margin: 0 auto 5rem;
  text-align: center;
}

.section-heading {
  font-size: 2rem;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 1.5rem;
  letter-spacing: -0.5px;
}

.lead-text {
  font-size: 1.25rem;
  line-height: 1.8;
  color: #4a5568;
}

.content-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 3rem;
  margin-bottom: 5rem;
}

.content-block {
  padding: 2.5rem;
  background-color: #f7fafc;
  border-left: 4px solid #2c5282;
}

.block-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 1rem;
}

.block-text {
  font-size: 1rem;
  line-height: 1.7;
  color: #4a5568;
}

.competencies-section {
  margin-bottom: 5rem;
}

.competencies-section .section-heading {
  text-align: center;
  margin-bottom: 3rem;
}

.competencies-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2.5rem;
}

.competency-item {
  text-align: center;
  padding: 2rem;
  background-color: #ffffff;
  border: 1px solid #e5e7eb;
  transition: all 0.3s ease;
}

.competency-item:hover {
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
  transform: translateY(-5px);
}

.competency-icon {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.competency-item h4 {
  font-size: 1.125rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.75rem;
}

.competency-item p {
  font-size: 0.9375rem;
  color: #6b7280;
  line-height: 1.6;
}

.cta-block {
  text-align: center;
  padding: 4rem 3rem;
  background-color: #1a1a1a;
  color: white;
  margin: 0 -3rem;
}

.cta-heading {
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 1rem;
  letter-spacing: -0.5px;
}

.cta-text {
  font-size: 1.125rem;
  color: #cbd5e0;
  margin-bottom: 2.5rem;
}

.cta-buttons {
  display: flex;
  gap: 1.5rem;
  justify-content: center;
  flex-wrap: wrap;
}

.btn {
  display: inline-block;
  padding: 1rem 2.5rem;
  text-decoration: none;
  font-weight: 600;
  font-size: 0.875rem;
  letter-spacing: 1px;
  transition: all 0.3s ease;
  border: 2px solid transparent;
}

.btn-primary {
  background-color: #2c5282;
  color: white;
  border-color: #2c5282;
}

.btn-primary:hover {
  background-color: #2a4365;
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(44, 82, 130, 0.3);
}

.btn-secondary {
  background-color: transparent;
  color: white;
  border-color: white;
}

.btn-secondary:hover {
  background-color: white;
  color: #1a1a1a;
}

@media (max-width: 1024px) {
  .container {
    padding: 0 2rem;
  }

  .content-grid {
    gap: 2rem;
  }

  .competencies-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 2rem;
  }

  .cta-block {
    margin: 0 -2rem;
  }
}

@media (max-width: 768px) {
  .container {
    padding: 0 1.5rem;
  }

  .page-header {
    padding: 3rem 0;
  }

  .page-title {
    font-size: 2.25rem;
  }

  .content-section {
    padding: 3rem 0 4rem;
  }

  .intro-block {
    margin-bottom: 3rem;
  }

  .section-heading {
    font-size: 1.75rem;
  }

  .lead-text {
    font-size: 1.0625rem;
  }

  .content-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
    margin-bottom: 3rem;
  }

  .content-block {
    padding: 1.5rem;
  }

  .competencies-section {
    margin-bottom: 3rem;
  }

  .competencies-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }

  .cta-block {
    padding: 3rem 1.5rem;
    margin: 0 -1.5rem;
  }

  .cta-heading {
    font-size: 1.75rem;
  }

  .cta-buttons {
    flex-direction: column;
    align-items: stretch;
  }

  .btn {
    width: 100%;
  }
}
</style>
