<template>
  <div class="home">
    <section class="hero">
      <div class="hero-overlay"></div>
      <div class="container">
        <div class="hero-content">
          <h1 class="hero-title">Strategic Real Estate Development</h1>
          <p class="hero-subtitle">
            Transforming solid concepts into feasible, high-quality developments through tactical planning and clear analysis.
          </p>
          <div class="hero-actions">
            <router-link to="/projects" class="btn btn-primary">VIEW PORTFOLIO</router-link>
            <router-link to="/resume" class="btn btn-secondary">VIEW RESUME</router-link>
          </div>
        </div>
      </div>
    </section>

    <section class="intro">
      <div class="container">
        <div class="intro-content">
          <!-- <h2 class="section-title">Building Tomorrow's Landmarks</h2> -->
          <h2 class="section-title">Building Desirable Communities</h2>
          <p class="intro-text">
            My name is Anthony Fletcher. I’m a real estate development professional with experience in financial analysis, pro forma modeling, and strategic project planning, grounded in hands-on construction and site experience. I leverage this combination of field insight and disciplined evaluation to support the successful planning and execution of high-quality, profitable development projects.
          </p>
          <router-link to="/about" class="link-arrow">Learn more about my approach →</router-link>
        </div>
      </div>
    </section>

    <section class="cta-section">
      <div class="container">
        <div class="cta-content">
          <h2 class="cta-title">Explore My Work</h2>
          <p class="cta-text">View detailed documentation and case studies of completed projects</p>
          <router-link to="/projects" class="btn btn-large">VIEW ALL PROJECTS</router-link>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.home {
  width: 100%;
}

.container {
  max-width: 100%;
  margin: 0 auto;
  padding: 0 4rem;
}

.hero {
  position: relative;
  background: linear-gradient(135deg, #1a1a1a 0%, #2d3748 100%);
  color: white;
  padding: 8rem 0 10rem;
  overflow: hidden;
}

.hero-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><rect width="100" height="100" fill="none"/><path d="M0 0L100 100M100 0L0 100" stroke="rgba(255,255,255,0.03)" stroke-width="1"/></svg>');
  opacity: 0.5;
}

.hero-content {
  position: relative;
  z-index: 1;
  max-width: 900px;
  margin: 0 auto;
  text-align: center;
}

.hero-title {
  font-size: 4rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
  line-height: 1.2;
  letter-spacing: -1px;
}

.hero-subtitle {
  font-size: 1.5rem;
  color: #cbd5e0;
  margin-bottom: 3rem;
  line-height: 1.6;
  font-weight: 300;
}

.hero-actions {
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

.btn-large {
  padding: 1.25rem 3rem;
  font-size: 1rem;
}

.intro {
  padding: 6rem 0;
  background-color: #ffffff;
}

.intro-content {
  max-width: 900px;
  margin: 0 auto;
  text-align: center;
}

.section-title {
  font-size: 2.5rem;
  font-weight: 700;
  margin-bottom: 2rem;
  color: #1a1a1a;
  letter-spacing: -0.5px;
}

.intro-text {
  font-size: 1.125rem;
  line-height: 1.8;
  color: #4a5568;
  margin-bottom: 2rem;
}

.link-arrow {
  color: #2c5282;
  text-decoration: none;
  font-weight: 600;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.link-arrow:hover {
  color: #2a4365;
  transform: translateX(5px);
  display: inline-block;
}

.cta-section {
  padding: 6rem 0;
  background-color: #1a1a1a;
  color: white;
}

.cta-content {
  text-align: center;
  max-width: 700px;
  margin: 0 auto;
}

.cta-title {
  font-size: 2.5rem;
  font-weight: 700;
  margin-bottom: 1rem;
  letter-spacing: -0.5px;
}

.cta-text {
  font-size: 1.125rem;
  color: #cbd5e0;
  margin-bottom: 2.5rem;
  line-height: 1.6;
}

@media (max-width: 1024px) {
  .container {
    padding: 0 2rem;
  }

  .hero {
    padding: 6rem 0 8rem;
  }

  .hero-title {
    font-size: 3rem;
  }
}

@media (max-width: 768px) {
  .container {
    padding: 0 1.5rem;
  }

  .hero {
    padding: 4rem 0 6rem;
  }

  .hero-title {
    font-size: 2.25rem;
  }

  .hero-subtitle {
    font-size: 1.125rem;
  }

  .section-title {
    font-size: 2rem;
  }

  .cta-title {
    font-size: 2rem;
  }
}
</style>
